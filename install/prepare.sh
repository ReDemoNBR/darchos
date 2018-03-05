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

init "Creating log files"
touch $PACKAGES_FILE
touch $ERROR_FILE
touch $FAILED_PACKAGES_FILE
end

copy "/etc/pacman.conf"
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

init "Ranking best mirrors"
# Use best mirrors
pacman -S --force --noconfirm pacman-mirrorlist &> /dev/null
cp --force /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
cp --force /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.tmp
## Uncomment all mirrors
sed --in-place '/Server = /s/^#\s*//g' /etc/pacman.d/mirrorlist.tmp
## Remove all commented lines
sed --in-place '/^#/ d' /etc/pacman.d/mirrorlist.tmp
## Remove GeoIP in order to rank mirrors without it
sed --in-place '/^Server = http:\/\/mirror.archlinuxarm.org/ d' /etc/pacman.d/mirrorlist
rankmirrors -n 0 /etc/pacman.d/mirrorlist.tmp > /etc/pacman.d/mirrorlist
## Re-add GeoIP as last resort for pacman mirrors
echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo' >> /etc/pacman.d/mirrorlist
refresh_pacman
rm /etc/pacman.d/mirrorlist.tmp
end

## Adding ArchStrike repository is different from the others
for repo in "${REPOSITORIES[@]}"; do
    add_repository "$repo"
done

finish "Preparing done"