#!/bin/bash

## test if is running as root
if [[ $EUID -ne 0 ]]; then
	echo "must run as root, preferably not using sudo"
	exit 1
else
	echo "Running as root... OK"
fi

## check if /darchos exists
if [[ ! -d /darchos ]]; then
	echo "directory /darchos does not exist"
    exit 1
fi

## test internet connection
echo -n "Testing internet... "
ping -c 4 8.8.8.8 &> /dev/null
if [[ $? -ne 0 ]]; then
	echo "Fail"
	exit 1
else
	echo "OK"
fi
