#!/bin/bash

## functions
source lib/message.sh
source lib/pacman.sh

clear
title "Installing initial packages"

## Install ArchLinux and ArchLinuxARM keyrings
install archlinux-keyring archlinuxarm-keyring
## Install ca-certificates
install ca-certificates ca-certificates-utils ca-certificates-cacert ca-certificates-mozilla
## Update all packages
subtitle "Updating all installed packages"
update_system

## Install basic packages
install base base-devel coreutils
## Install initial util
install bash-completion git icu tk vi vim wget yajl

finish "Base system installed"