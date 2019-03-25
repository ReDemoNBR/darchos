#!/bin/bash

## functions
source lib/message.sh

## constants
source conf/darchos.conf
source config.txt


function refresh_aur() {
    pikaur -Syy &> /dev/null
}

function install_aur() {
    local package error attempts message_template1 message_template2 backspaces
    pikaur -Sy &> /dev/null
    for package in "$@"; do
        [[ -z $( cat $PACKAGES_FILE | grep --line-regexp $package ) ]] && echo "$package" >> $PACKAGES_FILE
    done
    for package in "$@"; do
        if [[ -n $( pikaur -Qqs $package | grep --line-regexp $package ) ]]; then
            echo "$package already installed" >> $ERROR_FILE
        elif [[ -z $( pikaur -Sqs $package | grep --line-regexp $package ) ]]; then
            echo "$package not found by yaourt" >> $ERROR_FILE
        else
            attempts=0
            error=""
            init "Installing package with yaourt: $package"
            while pikaur -S --noedit --noconfirm $package &> /dev/null; [[ $? -ne 0 && $attempts -lt $MAX_ATTEMPTS ]]; do
                ((attempts++))
                message_template1=" failed (attempt #"
                message_template2=")... "
                if [[ $attempts -eq 1 ]]; then
                    echo -en "${message_template1}${attempts}$message_template2"
                else
                    backspaces=""
                    until [[ $((${#backspaces}/2)) -gt $((${#message_template1}+${#message_template2})) ]]; do
                        backspaces="${backspaces}\b"
                    done
                    echo -en "${backspaces}${message_template1}${attempts}$message_template2"
                fi
                if [[ $attempts -lt $MAX_ATTEMPTS ]]; then
                    echo "Error while installing ${package}... attempt $attempts" >> $ERROR_FILE
                    pikaur -Syy &> /dev/null
                else
                    end "Giving up... will try again in another moment"
                    echo "Gave up trying to install package $package with yaourt" >> $ERROR_FILE
                    error=1
                fi
            done
            [[ -z $error ]] && end
        fi
    done
}

function update_aur() {
    pikaur -Syyu --noedit --noconfirm &> /dev/null
}

function check_install_aur() {
    package=$( pikaur -Sqs $1 )
    [[ -n $package && "$package" == "$1" && -z $( pikaur -Qqs $1 | grep --line-regexp $1 ) ]] && install_aur $1
}

function search_language_packs() {
    local basename languages=() lang language OPTIND
    while getopts ":n:L:" option; do
        case $option in
            n)
                basename="$OPTARG" >&2
                ;;
            L)
                for lang in $OPTARG; do
                    languages+=("$lang")
                done
                ;;
            \?)
                echo "Invalid option -$OPTARG"
                exit 1
                ;;
        esac
    done
    for language in "${languages[@]}"; do
        ## Will test for pt_BR, pt_br, pt-BR, pt-br and pt (using 'pt_BR' locale as example)
        lowercase=${language,,}
        check_install_aur "${basename}-${language}" ## pt_BR
        check_install_aur "${basename}-${lowercase}" ## pt_br
        check_install_aur "${basename}-${language//_/-}" ## pt-BR
        check_install_aur "${basename}-${lowercase//_/-}" ## pt-br
        check_install_aur "${basename}-${language%%_*}" ## pt
    done
}