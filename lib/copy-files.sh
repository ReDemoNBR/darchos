#!/bin/bash

## functions
source lib/message.sh

## variables
source conf/darchos.conf
source config.txt

## generic copy function that create parent folders if necessary and adds --recursive flags if it's a directory
function copy_gen() {
    local from=$1 to="${2:-$from}"
    init "Copying $from to $to"
    if [[ -d $from ]]; then
        mkdir --parents "$to"
        cp --force --archive "${from}/"* "$to"
    else
        mkdir --parents "${to%/*}"
        cp --force "$from" "$to"
    fi
    end
}

## function to copy files from DArchOS resources folder
function copy() {
    local from=$1 to="${2:-$from}"
    copy_gen ${RESOURCES_FOLDER:?}$from $to
    [[ $( echo $to | cut --delimiter '/' --fields 1,2,3 ) == "/home/$USER_NAME" ]] && chown --recursive "${USER_NAME}:$USER_NAME" "$to"
}

## function that will copy files from DArchOS resources folder to user's home
function copy_user() {
    local from="/user-home/$1" to="/home/${USER_NAME}/.$1"
    copy "$from" "$to"
}

## function that will copy files from DArchOS resources folder to root's home
function copy_root() {
    local from to
    ## if its an absolute path, then it will use it, otherwise it will get the file from user-home
    if [[ $1 == /* ]]; then
        from="$1"
        to="/root/.${2:-$from}"
    else
        from="/user-home/$1"
        to="/root/.${2:$1}"
    fi
    copy "$from" "$to"
}