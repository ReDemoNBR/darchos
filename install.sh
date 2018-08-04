#!/bin/bash


full_path="$( pwd -P )/$0"
cd "${full_path%/*}"
path_here=$( pwd )

source config.txt
source conf/darchos.conf

function run() {
    local script="install/${1}.sh" status
    cd "$path_here"
    ## skip running scripts if it is the server version and is in the list of standard version only
    if [[ -n "$SERVER_VERSION" && -n $( echo "${STANDARD_VERSION_ONLY_SCRIPTS[*]}" | grep --word-regexp "$1") ]]; then
        echo "$script is exclusive to DArchOS standard version... skipping"
        return
    fi
    if [[ -f "$script" ]]; then
        [[ ! -x $script ]] && chmod u+x "$script"
        $script
        status="$?"
        [[ "$status" -ne 0 ]] && exit "$status"
    else
        echo "$script file not found"
    fi
}

run "wifi"

clear
echo "Waiting $WAIT_SECONDS_FOR_INTERNET seconds so internet connection is fully stabilished..."
sleep "$WAIT_SECONDS_FOR_INTERNET"

run "errors"

# disable powersave and TTY from getting blank with user inactivity
setterm -blank 0 -powersave off

run "prepare"
run "base-system"
run "aur-support"
run "manage-users"
run "hardware-specific"
run "general-configs"
run "swapfile"
run "resize-tmp"
run "minimal-packages"
run "dev-packages"
run "essential-system"
run "util-applications"
run "themes"
run "funny-packages"
run "retry-installation"
run "user-minimal-setup"
run "user-extended-setup"
run "system-setup"
run "wrapup"

clear
echo "Rebooting system..."
sleep "$SLEEP_TIME"

shutdown --reboot now