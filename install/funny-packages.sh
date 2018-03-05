#!/bin/bash

## functions
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

clear
title "Installing some funny packages"

install asciiquarium cowsay ponysay sl
install_aur bsod funny-manpages

finish "Funny packages installed"