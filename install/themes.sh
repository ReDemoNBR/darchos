#!/bin/bash

## functions
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

clear
title "Installing themes and styles"

# Fonts
install ttf-dejavu ttf-fira-mono ttf-fira-sans ttf-freefont ttf-monaco ttf-opensans ttf-roboto
install_aur ttf-fira-code ttf-roboto-mono ttf-roboto-slab

# Adapta
install adapta-gtk-theme papirus-icon-theme

# Numix cursor
install_aur numix-cursor-theme-git

# Wallpapers
install archstrike-wallpapers
install_aur adapta-backgrounds

finish "Themes and styles installed"