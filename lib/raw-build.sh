#!/bin/bash

## function
source lib/pacman.sh
source lib/run-as-normal-user.sh
source lib/message.sh

## constants
source conf/darchos.conf


errors=0

function execute_as_user() {
    run_as_normal_user "$@" &> /dev/null
    ((errors+=$?))
}


function raw_build() {
    local package=$1
    ## tries to install binaries from repositories before building
    check_install "$package"
    if [[ -z $( pacman -Qqs ^${package}$ | grep --line-regexp $package ) ]]; then
        errors=0

        subtitle "Building $package from source"

        execute_as_user "mkdir --parents $BUILD_FOLDER"
        init "Downloading PKGBUILD"
        execute_as_user "cd $BUILD_FOLDER ; git clone ${AUR_URL}${package}.git $package &> /dev/null"
        prog "Building"
        execute_as_user "cd ${BUILD_FOLDER}/$package ; makepkg &> /dev/null"
        prog "Installing"
        pacman -U --noconfirm "${BUILD_FOLDER}/${package}/${package}"*.pkg.tar.xz &> /dev/null
        prog "Removing source files"
        rm --force --recursive "$BUILD_FOLDER"
        if [[ $errors -eq 0 ]]; then
            end
        else
            end "Failed"
            echo "Failed to raw build $package" >> $ERROR_FILE
        fi
    fi
}