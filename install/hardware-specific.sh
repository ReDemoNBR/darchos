#!/bin/bash

## functions
source lib/daemon-control.sh
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

clear
title "Installing hardware specific packages"

## Install raspberry-pi required packages (if not already installed)
install raspberrypi-firmware raspberrypi-bootloader raspberrypi-bootloader-x
## Install fake-hwclock as RPi doesn't have RTC
install fake-hwclock
daemonctl -E fake-hwclock
## Install HRNG driver
install rng-tools
echo "RNGD_OPTS=\"-o /dev/random -r /dev/hwrng\"" > /etc/conf.d/rngd
daemonctl -E rngd
## Install RPi Bluetooth
install_aur pi-bluetooth
daemonctl -E brcm43438

finish "Hardware specific packages installed"