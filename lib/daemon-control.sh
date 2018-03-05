#!/bin/bash

## functions
source lib/message.sh

## constants
source conf/darchos.conf


function name_the_daemon() {
    local daemon_type=${1##*.}
    [[ "$daemon_type" == "$1" ]] && daemon_type=""
    echo "${1%.*}.${daemon_type:="service"}"
}

function operate_daemon() {
    local n operation=$1 daemon=$2
    n=$((${#operation}-1))
    ## if ends in 'e', it will be removed, if it is 'stop' the last character will be repeated, otherwise it is normal
    if [[ "${operation:$n:1}" == "e" ]]; then
        init "${operation:0:$n}ing $daemon"
    elif [[ "$operation" == "stop" ]]; then
        init "${operation}${operation:$n:1}ing $daemon"
    else
        init "${operation}ing $daemon"
    fi
    systemctl "$operation" "$daemon" &> /dev/null
    if [[ $? -ne 0 ]]; then
        echo "Could not $1 $daemon" >> $ERROR_FILE
        end "fail"
    else
        end
    fi
}

function daemon_exists() {
    [[ -a "/usr/lib/systemd/system/$daemon" ]] && echo 1
}

function daemonctl() {
    local daemon_name daemon option OPTIND
    while getopts ":d:D:e:E:r:" option; do
        case $option in
            d)
                daemon_name=$OPTARG >&2
                daemon=$( name_the_daemon $daemon_name )
                systemctl is-enabled "$daemon" &> /dev/null
                [[ $? -eq 0 ]] && operate_daemon disable "$daemon"
                ;;
            D)
                daemon_name=$OPTARG >&2
                daemon=$( name_the_daemon $daemon_name )
                systemctl is-active "$daemon" &> /dev/null
                [[ $? -eq 0 ]] && operate_daemon stop "$daemon"
                systemctl is-enabled "$daemon" &> /dev/null
                [[ $? -eq 0 ]] && operate_daemon disable "$daemon"
                ;;
            e)
                daemon_name=$OPTARG >&2
                daemon=$( name_the_daemon $daemon_name )
                [[ -n $( daemon_exists "$daemon_name" ) ]] && operate_daemon enable "$daemon"
                ;;
            E)
                daemon_name=$OPTARG >&2
                daemon=$( name_the_daemon $daemon_name )
                if [[ -n $( daemon_exists "$daemon_name" ) ]]; then
                    operate_daemon start "$daemon"
                    operate_daemon enable "$daemon"
                fi
                ;;
            r)
                daemon_name=$OPTARG >&2
                daemon=$( name_the_daemon $daemon_name )
                [[ -n $( daemon_exists "$daemon_name" ) ]] && operate_daemon restart "$daemon"
                ;;
            \?)
                echo "Invalid option -$OPTARG"
                exit 1
                ;;
        esac
    done
}