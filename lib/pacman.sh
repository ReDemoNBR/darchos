#!/bin/bash

## functions
source lib/message.sh

## variables
source conf/darchos.conf


function refresh_pacman() {
    pacman -Syy &> /dev/null
}

function install() {
    local packages=() attempts=0 message_template1 message_template2 backspaces
    pacman -Sy &> /dev/null
    for package in "$@"; do
        [[ -z $( cat /darchos/packages.txt | grep --line-regexp "$package" ) ]] && echo "$package" >> $PACKAGES_FILE
        if [[ -n $( pacman -Sqs ^${package}$ | grep --line-regexp $package ) || -n $( pacman -Sq --groups $package ) ]]; then
            packages+=("$package")
        else
            echo "$package not found by pacman" | tee --append $ERROR_FILE
        fi
    done
    if [[ ${#packages[@]} -gt 1 ]]; then
        init "Installing packages: ${packages[*]}"
    else
        init "Installing package: ${packages[*]}"
    fi

    while pacman -S --needed --noconfirm "${packages[@]}" &> /dev/null; [[ $? -ne 0 && attempts -gt $MAX_ATTEMPTS ]]; do
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
            echo "Error while installing ${packages[*]}... attempt $attempts" >> $ERROR_FILE
            refresh_pacman
        else
            end "Giving up. For now... will try again in another moment"
            echo "Gave up trying to install packages ${packages[*]} with pacman" >> $ERROR_FILE
            exit 0
        fi
    done
    end
}

function update_system() {
    pacman -Syyu --noconfirm &> /dev/null
}

function check_install() {
    [[ -n $( pacman -Sqs ^${1}$ ) && -z $( pacman -Qqs ^${1}$ ) ]] && install $1
}

function rank_pacman_mirrors() {
    local pacman_dir="/etc/pacman.d"
    # Use best mirrors
    pacman -S --noconfirm pacman-mirrorlist &> /dev/null
    cp --force "${pacman_dir}/mirrorlist" "${pacman_dir}/mirrorlist.bak"
    cp --force "${pacman_dir}/mirrorlist" "${pacman_dir}/mirrorlist.tmp"
    ## Uncomment all mirrors
    sed --in-place '/Server = /s/^#\s*//g' "${pacman_dir}/mirrorlist.tmp"
    ## Remove all commented lines
    sed --in-place '/^#/ d' "${pacman_dir}/mirrorlist.tmp"
    ## Remove GeoIP in order to rank mirrors without it
    sed --in-place '/^Server = http:\/\/mirror.archlinuxarm.org/ d' "${pacman_dir}/mirrorlist"
    rankmirrors -n 0 "${pacman_dir}/mirrorlist.tmp" > "${pacman_dir}/mirrorlist"
    ## Re-add GeoIP as last resort for pacman mirrors
    echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo' >> "${pacman_dir}/mirrorlist"
    refresh_pacman
    rm "${pacman_dir}/mirrorlist.tmp"
}