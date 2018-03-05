#!/bin/bash

## variables
source conf/darchos.conf
source config.txt

function run_as_normal_user() {
    local user
    id -u $USER_NAME
    if [[ $? -eq 0 ]]; then
        user=$USER_NAME
    else
        if [[ -z $user ]]; then
            for name in /home/*; do
                user=${name##*/}
                break
            done
        fi
    fi
    if [[ -z $user ]]; then
        echo "Can't execute command as normal user if there are no normal users. Please create one first" >> $ERROR_FILE
        exit 1
    fi
    su --login "$user" --command "$@" &> /dev/null
}
