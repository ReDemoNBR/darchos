#!/bin/bash

packages=()

pacman -Sy &> /dev/null
for package in "$@"; do
    if [[ -z $(cat /darchos/packages.txt | grep -w "$package") ]]; then
        echo "$package" >> /darchos/packages.txt
    fi
    if [[ -z $( pacman -Sqs ^${package}$ ) ]]; then
        echo "$package not found by pacman" >> /darchos/errors.txt
    else
        packages+=("$package")
    fi
done

attempts=0

# Print "packages" (in plural) if there is more than 1 package to install
if [[ ${#packages[@]} -gt 1 ]]; then
    echo -n "Installing packages: "
else
    echo -n "Installing package: "
fi
echo -n "${packages[*]}..."

while pacman -S --needed --noconfirm ${packages[*]} &> /dev/null; [[ $? -ne 0 && attempts -lt 5 ]]; do
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
        echo "Error while installing ${packages[*]}... attempt $attempts" >> /darchos/errors.txt
        pacman -Syy &> /dev/null
    else
        echo "Giving up. For now... will try again in another moment"
        echo "Gave up trying to install packages ${packages[*]} with pacman" >> /darchos/errors.txt
        exit 1
    fi
done
echo " done"