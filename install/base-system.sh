#!/bin/bash

## functions
source lib/message.sh
source lib/pacman.sh

clear
title "Installing initial packages"

## Install ca-certificates
install ca-certificates ca-certificates-utils ca-certificates-mozilla
## Install pacman utils
install pacman-contrib

## Rank best mirrors
init "Ranking best mirrors"
rank_pacman_mirrors
end

## Update all installed packages
subtitle "Updating all installed packages"
update_system

## Install base core packages
install base base-devel coreutils ncurses
## Install initial util packages
install bash-completion git icu net-tools tk traceroute wget yajl

finish "Base system installed"