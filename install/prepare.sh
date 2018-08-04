#!/bin/bash

## functions
source lib/add-repository.sh
source lib/pacman.sh
source lib/daemon-control.sh
source lib/copy-files.sh
source lib/message.sh

## constants
source conf/repos.conf
source conf/darchos.conf
source config.txt

clear
title "Preparing system to install"

[[ -z $WIFI_SSID || -z $WIFI_PASS ]] && daemonctl -D "wpa_supplicant"

if [[ -n $SSH ]]; then
    if [[ "$SSH" == 0 ]]; then
        daemonctl -D sshd
    else
        daemonctl -E sshd
    fi
fi
init "Creating log files"
touch $PACKAGES_FILE
touch $ERROR_FILE
touch $FAILED_PACKAGES_FILE
end

copy "/etc/pacman_${ARCH}.conf" "/etc/pacman.conf"
copy "/etc/pacman.d/repos.conf"
copy "/etc/motd"
copy "/etc/locale.gen"
## adding hooks for linux kernel upgrades
copy "/usr/share/libalpm/hooks/update-os-release.hook"
copy "/usr/share/libalpm/scripts/update-os-release.sh"

init "Creating symbolic link for os-release"
ln --force --symbolic "/usr/lib/os-release" "/etc/os-release" &> /dev/null
end

init "Initializing pacman"
pacman-key --init &> /dev/null
refresh_pacman
end

## Adding ArchStrike repository is different from the others
repositories="REPOSITORIES_${ARCH^^}[@]"
for repo in "${!repositories}"; do
    add_repository "$repo"
done

finish "Preparing done"