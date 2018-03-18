#!/bin/bash

## functions
source lib/message.sh

## variables
source conf/darchos.conf


## test if is running as root
init "Running as root"
if [[ $EUID -ne 0 ]]; then
    prog "fail"
	end "must run as root, preferably not using sudo"
	exit 1
else
	end "OK"
fi
## check if /darchos exists
if [[ ! -d "$DARCHOS_FOLDER" ]]; then
	echo "directory $DARCHOS_FOLDER does not exist"
    exit 1
fi
if [[ ! -f "${DARCHOS_FOLDER}/config.txt" ]]; then
    echo "file ${DARCHOS_FOLDER}/config.txt not found"
    exit 1
fi

## test internet connection
init "Testing internet"
ping -q -w 1 -c 4 8.8.8.8 &> /dev/null
if [[ $? -ne 0 ]]; then
	end "fail"
	exit 1
else
	end "OK"
fi
