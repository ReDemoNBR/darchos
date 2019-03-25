#!/bin/bash

## functions
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

## constants
source config.txt

languages=("$LANGUAGE")
languages+=("${ADDITIONAL_LANGUAGES[@]}")

function install_langs() {
    subtitle "Installing language packs for ${2:-$1}"
    search_language_packs -n $1 -L "${languages[*]}"
}

clear
title "Installing development packages"

## JDK/JRE
install jdk-openjdk jre-openjdk jre-openjdk-headless

# Development
install nodejs npm lynx

# Text editors
install vi vim
install_langs vim-spell vim
install_aur micro nano-syntax-highlighting-git

# Utils
install hdparm htop screenfetch gparted parted linux-tools neofetch

# Aspell, hunspell and hyphen
install aspell
install_langs aspell
install hunspell
install_langs hunspell
install hyphen
install_langs hyphen

finish "Dev applications installed"