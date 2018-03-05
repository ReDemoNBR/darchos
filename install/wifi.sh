#!/bin/bash

## functions
source lib/message.sh

## constants
source config.txt

[[ -z $WIFI_PASS || -z $WIFI_SSID ]] && exit 0

title "Setting up wifi"

subtitle "Creating wifi configuration"
wifi_conf="/etc/netctl/wifi"
cp --force "/etc/netctl/examples/wireless-wpa" "$wifi_conf"
sed --in-place "s/ESSID='MyNetwork'/ESSID='${WIFI_SSID}'/g" "$wifi_conf"
sed --in-place "s/Key='WirelessKey'/Key='${WIFI_PASS}'/g" "$wifi_conf"

subtitle "Starting wifi configuration"
netctl start wifi &> /dev/null
if [[ $? -ne 0 ]]; then
    echo "failed... could not start wifi configuration"
    exit 1
fi
subtitle "Enabling wifi configuration"
netctl enable wifi &> /dev/null
if [[ $? -ne 0 ]]; then
    end "failed... could not enable wifi configuration"
    exit 1
fi

finish "Wireless setup done"
