#!/bin/bash

while [[ $* ]]; do
    OPTIND=1
    if [[ $1 =~ ^- ]]; then
        getopts ":u:" option
        case $option in
            u)
            username=$OPTARG
            shift
            ;;
            a)
            arch=$OPTARG
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
        package=$1
    fi
    shift
done

if [[ -z $username ]]; then
    username="root"
fi
if [[ -z $arch ]]; then
    arch="armv7h"
fi

function run {
    su --login "$username" --command "$@"
}

function run_no_fail {
    attempts=0
    while su --login "$username" --command "$*"; [[ $? -ne 0 ]]; do
        ((attempts++))
        echo "Error executing: su --login \"$username\" --command \"$*\""
    done
}

echo "$package" | tee --append /darchos/packages.txt

## Download and alter "arch" property in PKGBUILD
run "mkdir --parents /tmp/build"
run_no_fail "cd /tmp/build ; yaourt -G $package"
run "sed --in-place \"s/^arch=.*/arch=('$arch')/\" /tmp/build/$package/PKGBUILD"
run_no_fail "yaourt -P --noconfirm /tmp/build/$package"
pacman -U /tmp/build/$package/${package}*.pkg.tar.xz
rm --force --recursive /tmp/build
