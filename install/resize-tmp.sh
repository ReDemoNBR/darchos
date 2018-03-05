#!/bin/bash

## functions
source lib/message.sh

## constants
source config.txt

if [[ -z $TMP_SIZE ]]; then
    finish "No /tmp tmpfs resize"
    exit 0
fi
title "Resizing /tmp temporary file system to ${TMP_SIZE}B"

init "Adding configuration to fstab"
if [[ -z $( grep /tmp /etc/fstab ) ]]; then
    echo "tmpfs /tmp tmpfs rw,nodev,nosuid,size=$TMP_SIZE 0 0" >> /etc/fstab
    end
else
    prog "Not needed (already done)"
    end
fi

finish "/tmp resized to ${TMP_SIZE}B from next boot"