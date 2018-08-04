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
title "Installing minimal version packages"

# Install customizepkg
install_aur customizepkg
copy "/etc/customizepkg.d/"
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
# Gnome keyrings
install gnome-keyring

finish "Minimal version packages installed"