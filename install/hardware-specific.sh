#!/bin/bash

username=$1

clear
echo -e "Installing hardware specific packages...\n"

function install() {
    bash install/pacman-install.sh "$@"
}

function install_aur() {
    bash install/yaourt-install.sh -u "$username" "$@"
}

function enable() {
    echo -n "Enabling $1 service daemon..."
    systemctl enable "${1}.service" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Could not enable ${1}.service"
    fi
    systemctl start "${1}.service" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Could not start ${1}.service"
    fi
    echo " done"
}

## Install raspberry-pi required packages (if not already installed)
install raspberrypi-firmware raspberrypi-bootloader raspberrypi-bootloader-x
## Install fake-hwclock as RPi doesn't have RTC
install fake-hwclock
enable fake-hwclock
## Install HRNG driver
install rng-tools
echo 'RNGD_OPTS="-o /dev/random -r /dev/hwrng"' > /etc/conf.d/rngd
enable rngd
## Install RPi Bluetooth
install_aur pi-bluetooth
enable brcm43438

echo "Hardware specific packages installed"
sleep 5