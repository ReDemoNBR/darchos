#!/bin/bash

## functions
source lib/copy-files.sh
source lib/daemon-control.sh
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

## constants
source conf/darchos.conf
source config.txt

clear
title "Installing essential system"

# Install X.org
install xorg-xinit xorg-server xorg-server-common xorg-xrandr xterm
# Install video driver
install mesa xf86-video-vesa xf86-video-fbdev
# Install audio
install alsa-firmware alsa-utils pulseaudio pulseaudio-alsa
# Install desktop environment (Xfce)
install xfce4 xfce4-goodies exo thunar thunar-archive-plugin thunar-media-tags-plugin xdg-utils xdg-user-dirs engrampa parole catfish file-roller unrar
install lynx ## required for building xdg-su
install_aur xdg-su mugshot
# Install packages to automount USB
install gvfs udisks2 thunar-volman
# Install display manager (LightDM GTK Greeter)
install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
# Install pamac (graphical interface to manage packages)
install_aur pamac-aur pamac-tray-appindicator

finish "Essential packages installed"