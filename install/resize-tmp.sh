#!/bin/bash

tmpsize=$1

clear
echo -e "Resizing /tmp temporary file system to ${tmpsize}B...\n"

echo -n "Adding configuration to fstab..."
echo "tmpfs /tmp tmpfs rw,nodev,nosuid,size=$tmpsize 0 0" >> /etc/fstab
echo " done"

echo "/tmp resized to ${tmpsize}B"
sleep 5