#!/bin/bash

## functions
source lib/raw-build.sh
source lib/message.sh

clear

function execute() {
    while raw_build "${1}"; [[ -z $( pacman -Qqs ^${1}$ | grep --line-regexp $1 ) ]]; do
        echo "Error while building $1 from source"
        pacman -Syy &> /dev/null
    done
}

title "Adding AUR support"
execute "package-query"
execute "yaourt"

finish "AUR support needed packages installed"