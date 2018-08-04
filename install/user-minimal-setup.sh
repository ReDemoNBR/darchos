#!/bin/bash

## functions
source lib/copy-files.sh
source lib/message.sh

## constants
source conf/darchos.conf
source config.txt

clear
if [[ "${USER_NAME:(-1)}" == "s" ]]; then
    title "Configurating ${USER_NAME}' home"
else
    title "Configurating ${USER_NAME}'s home"
fi

subtitle "Copying configuration files"
copy_user "bash_profile"
copy_user "bashrc"
copy_user "extend.bashrc"
copy_user "exports.bashrc"
copy_user "aliases.bashrc"
copy_user "nanorc"
copy_user "dir_colors"
copy_user "icons"
copy_user "config"

finish "Minimal user setup done"