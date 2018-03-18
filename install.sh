#!/bin/bash

full_path="$( pwd -P )/$0"
cd "${full_path%/*}"
path_here=$( pwd )

function run() {
    local script="install/${1}.sh" status
    cd "$path_here"
    if [[ -f $script ]]; then
        [[ ! -x $script ]] && chmod u+x "$script"
        $script
        status=$?
        [[ $status -ne 0 ]] && exit $status
    else
        echo "$script file not found"
    fi
}

run "wifi"

clear
echo "Waiting 10 seconds so internet connection is fully stabilished..."
sleep 10

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
run "essential-system"
run "util-applications"
run "themes"
run "funny-packages"
run "retry-installation"
run "user-setup"
run "system-setup"
run "wrapup"

clear
echo "Rebooting system..."
sleep 5

shutdown --reboot now