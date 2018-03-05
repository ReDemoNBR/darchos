#!/bin/bash

## Temporary script that will arrange desktop and remove itself after the desktop was successfully arranged
## This script should run only for the first time user logged in
## Regular users wouldn't even notice it

sleep 15
xfdesktop --arrange
if [[ $? -eq 0 ]]; then
    rm ~/.config/autostart/arrange.desktop
    rm ~/.tmp.sh
fi
xfdesktop --reload