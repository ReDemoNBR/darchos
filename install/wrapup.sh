#!/bin/bash

## functions
source lib/message.sh
source lib/daemon-control.sh
source lib/copy-files.sh

## constants
source conf/darchos.conf

clear
title "Finishing installation"

init "Copying useful DArchOS files to $DARCHOS_END_FOLDER"
## transfer user home standard configs
copy "/user-home" "${DARCHOS_END_FOLDER}/userconf"
end

init "Copying installation error log file to $DARCHOS_END_FOLDER"
copy_gen "$ERROR_FILE" "$ERROR_FILE_AFTER"
[[ -f $FAILED_PACKAGES_FILE ]] && copy_gen "$FAILED_PACKAGES_FILE" "$FAILED_PACKAGES_FILE_AFTER"
end

init "Copying up os-release"
copy "/usr/lib/os-release" "${DARCHOS_END_FOLDER}/os-release"
end

init "Disabling auto-run of first-boot install script"
rm --force --recursive "/etc/systemd/system/getty@tty1.service.d"
copy "/etc/systemd/logind.conf"
end

init "Removing DArchOS installation files"
rm --force --recursive "$DARCHOS_FOLDER"
end

daemonctl -e lightdm

finish "Installing done"