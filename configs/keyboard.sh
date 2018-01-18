#!/bin/bash

keyboard=$1

clear
echo -e "Configurating keyboard to use $keyboard layout...\n"

if [[ -f $keyboard ]]; then
    echo -n "Loading keys... "
    loadkeys "$keyboard"
    echo "done"
else
    echo "Could not find $keyboard keyboard layout" | tee --append /darchos/errors.txt
    exit 1
fi

echo "Keyboard configurated"
sleep 5