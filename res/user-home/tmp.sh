#!/bin/bash

## Temporary script that will arrange desktop and remove itself
## This script should run only for the first time user logged in
## Regular users wouldn't even notice it

sleep 10
xfdesktop --arrange
rm ~/.config/autostart/arrange.desktop
rm ~/.tmp.sh
