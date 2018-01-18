#!/bin/bash

hostname=$1

clear
echo -e "Naming host to ${hostname}...\n"

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

init "Adding hostname to /etc/hostname"
echo "$hostname" > /etc/hostname
end

host="127.0.1.1 localhost.localdomain"
init "Adding '$host $hostname' to /etc/hosts"
echo "$host $hostname" >> /etc/hosts
end

echo "Hostname changed"
sleep 5