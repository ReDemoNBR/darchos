#!/bin/bash

clear
echo -e "Installing initial packages...\n"

function install() {
    bash install/pacman-install.sh "$@"
}

## Install ArchLinux and ArchLinuxARM keyrings
install archlinux-keyring archlinuxarm-keyring
## Install ca-certificates
install ca-certificates ca-certificates-utils ca-certificates-cacert ca-certificates-mozilla
## Update all packages
echo -n "Updating all installed packages..."
pacman -Syyu --noconfirm &> /dev/null
echo " done"
## Install basic packages
install base base-devel coreutils yajl wget git tk vi vim bash-completion

echo "Base system installed"
sleep 5