#!/bin/bash

username=$1

clear
echo -e "Installing some funny packages...\n"

bash install/pacman-install.sh asciiquarium cowsay ponysay sl
bash install/yaourt-install.sh -u "$username" bsod

echo "Funny packages installed"
sleep 5