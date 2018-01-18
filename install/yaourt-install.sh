#!/bin/bash

packages=()

while [[ $* ]]; do
    OPTIND=1
    if [[ $1 =~ ^- ]]; then
        getopts ":u:" option
        case $option in
            u)
                username=$OPTARG
                shift
                ;;
            \?)
                echo "bad option -- $OPTARG"
                exit 1
                ;;
            :)
                echo "option -$OPTARG requires an argument"
                exit 1
                ;;
        esac
    else
        packages+=("$1")
    fi
    shift
done

if [[ -z $username ]]; then
    for name in /home/*; do
        username=$( echo "$name" | rev | cut --delimiter "/" --fields 1 | rev )
        break
    done
fi


yaourt -Sya &> /dev/null
for package in ${packages[*]}; do
    echo "$package" >> /darchos/packages.txt
    if [[ -n $( yaourt -Qqs ^${package}$ ) ]]; then
        echo "$package already installed" >> /darchos/errors.txt
    elif [[ -z $( yaourt -Sqs "$package" | grep -x "$package" ) ]]; then
        echo "$package not found by yaourt" >> /darchos/errors.txt
    else
        attempts=0
        echo -n "Installing package with yaourt: ${package}..."
        while su --login "$username" --command "yaourt -S --noconfirm $package &> /dev/null"; [[ $? -ne 0 && attempts -lt 5 ]]; do
            ((attempts++))
            message_template1=" failed (attempt #${attempts}"
            message_template2=")... "
            if [[ $attempts -eq 1 ]]; then
                echo -ne "${message_template1}\b${attempts}$message_template2"
            else
                backspaces=""
                until [[ $((${#backspaces}/2)) -gt ${#message_template2} ]]; do
                    backspaces="${backspaces}\b"
                done
                echo -ne "${message_template1}${backspaces}${attempts}$message_template2"
            fi
            if [[ $attempts -lt 5 ]]; then
                echo "Error while installing ${package}... attempt $attempts" >> /darchos/errors.txt
                yaourt -Syya &> /dev/null
            else
                echo "Giving up... will try again in another moment"
                echo "Gave up trying to install package $package with yaourt" >> /darchos/errors.txt
                exit 1
            fi
        done
        echo " done"
    fi
done