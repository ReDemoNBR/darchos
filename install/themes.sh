#!/bin/bash

username=$1

function install() {
    bash install/pacman-install.sh "$@"
}

function install_aur() {
    bash install/yaourt-install.sh -u "$username" "$@"
}

clear
echo -e "Installing themes and styles...\n"

# Fonts
install ttf-freefont ttf-croscore ttf-dejavu ttf-droid ttf-fira-mono ttf-fira-sans ttf-roboto ttf-ubuntu-font-family
install_aur ttf-carlito ttf-caladea ttf-monaco ttf-fira-code ttf-roboto-mono ttf-roboto-slab

# Arc Grey Theme
install_aur gtk-theme-arc-grey-git

# Numix Icons
install_aur numix-icon-theme-git numix-circle-icon-theme-git numix-cursor-theme-git numix-folders-git

echo -n "Configurating Numix Folders..."
cd /usr/share/numix-folders
echo -e "6\ngrey\n" | numix-folders -t &> /dev/null
cd - &> /dev/null
echo " done"

echo "Themes and styles installed"
sleep 5