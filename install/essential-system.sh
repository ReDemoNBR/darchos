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

# Install customizepkg
install_aur customizepkg
copy "/etc/customizepkg.d/"
# Install X.org
install xorg-xinit xorg-server xorg-server-common xorg-xrandr xterm
# Install video driver
install mesa xf86-video-vesa xf86-video-fbdev
# Install audio
install alsa-firmware alsa-utils pulseaudio pulseaudio-alsa
# Install desktop environment (Xfce)
install xfce4 xfce4-goodies exo thunar thunar-archive-plugin thunar-media-tags-plugin xdg-utils xdg-user-dirs engrampa parole catfish file-roller unrar
install_aur xdg-su mugshot
# Install packages to automount USB
install gvfs udisks2 thunar-volman
# Install display manager (LightDM GTK Greeter)
install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
# Install network manager
install networkmanager networkmanager-dispatcher-ntpd networkmanager-openvpn networkmanager-openconnect networkmanager-pptp nm-connection-editor network-manager-applet
## Disables Wifi through netctl and starts with NetworkManager
[[ -n $WIFI_SSID || -n $WIFI_PASS ]] && subtitle "Disabling wifi through netctl"
[[ $( netctl is-active wifi ) == "active" ]] && netctl stop wifi &> /dev/null
[[ $( netctl is-enabled wifi ) == "enabled" ]] && netctl disable wifi &> /dev/null
daemonctl -E dhcpcd -E NetworkManager
if [[ -n $WIFI_SSID && -n $WIFI_PASS ]]; then
    sleep $SLEEP_TIME
    attempts=$MAX_ATTEMPTS
    until [[ $attempts -eq 0 || -n $( nmcli device wifi | grep $WIFI_SSID ) ]]; do
        ((attempts--))
        echo "Did not find SSID $WIFI_SSID yet... Searching again..."
        sleep $SLEEP_TIME
    done
    subtitle "Reconnecting wifi through NetworkManager"
    nmcli device wifi connect $WIFI_SSID password $WIFI_PASS
    if [[ $? -ne 0 ]]; then
        sleep $SLEEP_TIME
        echo "Could not connect to wifi using networkmanager; SSID=$WIFI_SSID ; PASS=$WIFI_PASS" >> $ERROR_FILE
        echo "fail"
    fi
    sleep $SLEEP_TIME
else
    nmcli radio wifi off
fi

# Install bluetooth
install blueman bluez bluez-utils
daemonctl -E bluetooth
# Install Avahi
install avahi nss-mdns
daemonctl -E avahi-daemon
# Install pamac (graphical interface to manage packages)
install_aur pamac-aur pamac-tray-appindicator
# Syntax highlighting for nano text editor
install_aur nano-syntax-highlighting-git
# Gnome keyrings
install gnome-keyring
# User management GUI
install_aur gnome-system-tools

finish "Essential packages installed"