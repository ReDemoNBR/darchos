#!/bin/bash

user=$1
password=$2

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

if [[ -z $password ]]; then
    init "Removing password from $user"
    passwd --delete "$user"
else
    init "Giving password to $user"
    echo -e "${password}\n$password" | passwd "$user" &> /dev/null
fi
end