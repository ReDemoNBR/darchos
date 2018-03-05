#!/bin/bash

## functions
source lib/message.sh

## constants
source config.txt

if [[ -z $SWAPFILE_SIZE ]]; then
    finish "No swapfile creation"
    exit 0
fi

title "Creating swapfile with ${SWAPFILE_SIZE}B size"

if [[ -z $( grep /swapfile /etc/fstab ) ]]; then
    init "Alocating"
    fallocate --length "$SWAPFILE_SIZE" /swapfile &> /dev/null
    prog "Adjusting permissions"
    chmod 600 /swapfile &> /dev/null
    prog "Setting up"
    mkswap /swapfile &> /dev/null
    prog "Enabling"
    swapon /swapfile &> /dev/null
    end
    init "Adding to fstab so it loads on boot"
    echo "/swapfile none swap defaults 0 0" >> /etc/fstab
    end
else
    prog "Not needed (already done)"
    end
fi

finish "Swapfile created"