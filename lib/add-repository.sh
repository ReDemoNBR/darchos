#!/bin/bash

## functions
source lib/pacman.sh
source lib/message.sh

## constants
source conf/darchos.conf
source conf/repos.conf


function return_backup_conf {
    new_conf=$1
    backup_conf=$2
    prog "fail"
    prog "returing to old config"
    rm "$new_conf"
    cp --force "$backup_conf" "$new_conf"
}

function add_repository {
    local repo REPO
    local key_prop mirror_prop mirrorlist_prop name_prop packages_prop pretty_name_prop
    local key mirror mirrorlist name packages=() pretty_name treat_mirror status

    repo=$1
    REPO=${repo^^}
    REPO=${REPO//-/_}
    key_prop="${REPO}_KEY"
    mirror_prop="${REPO}_MIRROR"
    mirrorlist_prop="${REPO}_MIRRORLIST"
    name_prop="${REPO}_NAME"
    packages_prop="${REPO}_PACKAGES[@]"
    pretty_name_prop="${REPO}_PRETTY_NAME"
    siglevel_prop="${REPO}_SIGLEVEL"
    required_prop="${REPO}_REQUIRED"

    key=${!key_prop}
    mirror=${!mirror_prop}
    mirrorlist=${!mirrorlist_prop}
    name=${!name_prop}
    read -a packages <<< "${!packages_prop}"
    pretty_name=${!pretty_name_prop}
    siglevel=${!siglevel_prop}
    required=${!required_prop}
    if [[ -z $mirror ]]; then
        echo "$repo mirror not found" >> $ERROR_FILE
        exit 1
    fi
    if [[ -z $name ]]; then
        echo "$repo name not found" >> $ERROR_FILE
        exit 1
    fi
    pretty_name="${pretty_name:-$name}"

    subtitle "Adding $pretty_name repository"
    if [[ -n $mirrorlist ]]; then
        init "Adding $pretty_name temporary mirror to pacman configuration"
    else
        init "Adding $pretty_name mirror to pacman configuration"
    fi
    if [[ -z $( cat $REPOSITORIES_CONF_FILE | grep $mirror ) ]]; then
        cp --force "$REPOSITORIES_CONF_FILE" "$REPOSITORIES_CONF_BACKUP_FILE"
        echo -e "\n[${name}]" >> $REPOSITORIES_CONF_FILE
        [[ -n $siglevel ]] && echo "SigLevel = ${siglevel^}" >> $REPOSITORIES_CONF_FILE
        echo -e "Server = ${mirror}\n" >> $REPOSITORIES_CONF_FILE
        refresh_pacman
        if [[ $? -ne 0 ]]; then
            return_backup_conf "$REPOSITORIES_CONF_FILE" "$REPOSITORIES_CONF_BACKUP_FILE"
            echo "$pretty_name repository could not be added" >> $ERROR_FILE
            end
        else
            end
            if [[ -n $key ]]; then
                init "Setting up $pretty_name keys"
                pacman-key --recv-keys "$key" &> /dev/null
                pacman-key --lsign-key "$key" &> /dev/null
                end
            fi
            if [[ ${#packages[@]} -gt 0 ]]; then
                for package in "${packages[@]}"; do
                    install $package
                done
            fi
            if [[ -n $mirrorlist ]]; then
                init "Adding $pretty_name repository permanently"
                treat_mirror=${mirror%%/\$*}
                treat_mirror=${treat_mirror//"/"/"\/"}
                sed --in-place "/^Server = ${treat_mirror}/ d" $REPOSITORIES_CONF_FILE
                printf %s "$(cat $REPOSITORIES_CONF_FILE)" > $REPOSITORIES_CONF_FILE ## remove trailing lines
                echo -e "\nInclude = $mirrorlist" >> $REPOSITORIES_CONF_FILE
                refresh_pacman
                if [[ $? -ne 0 ]]; then
                    refresh_pacman # try again
                    if [[ $? -ne 0 ]]; then
                        return_backup_conf "$REPOSITORIES_CONF_FILE" "$REPOSITORIES_CONF_BACKUP_FILE"
                        if [[ -n $required ]]; then
                            echo "Could not add repository ${repo}... trying again"
                            add_repository ${repo}
                        else
                            echo "$pretty_name repository could not be added after using his mirrorlist" >> $ERROR_FILE
                        fi
                    fi
                fi
                end
            fi
            rm "$REPOSITORIES_CONF_BACKUP_FILE"
        fi
    else
        end "$pretty_name repository already added"
        echo "$pretty_name already added to $PACMAN_CONF" >> $ERROR_FILE
    fi
}