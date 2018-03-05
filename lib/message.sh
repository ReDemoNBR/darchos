#!/bin/bash

## handles messages for actions
## use 'init' to print something as initiated and then use 'end' for when it ends
## use 'prog' to print in the same line of 'init' in order to inform an update of that task

source conf/darchos.conf

function init() {
    echo -en "${1^}..."
}

function end() {
    echo -e " ${1:-done}"
}

function prog() {
    echo -en " ${1}..."
}

function subtitle() {
    echo -e "\n${1^^}"
}

function title() {
    echo -e "\n${1^^}\n"
}

function finish() {
    echo -e "\n${1^}"
    sleep $SLEEP_TIME
}