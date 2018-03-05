#!/bin/bash

## functions
source lib/message.sh


function change_password() {
    local username=$1 password=$2
    if [[ -z $password ]]; then
        init "Removing password from $username"
        passwd --delete "$username" &> /dev/null
    else
        init "Giving password to $username"
        echo -e "${password}\n$password" | passwd "$username" &> /dev/null
    fi
    end
}