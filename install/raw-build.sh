#!/bin/bash

package=$1
user=$2
errors=0

if [[ -z $user ]]; then
    for name in /home/*; do
        user=$( echo "$name" | rev | cut --delimiter "/" --fields 1 | rev )
        break
    done
fi
function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

function run() {
    su --login "$user" --command "$*" &> /dev/null
    ((errors+=$?))
}

clear
echo -e "Building $package from source...\n\n"

init "Creating folder in /tmp"
run "mkdir --parents /tmp/build"
end
init "Getting PKGBUILD"
run "cd /tmp/build ; git clone https://aur.archlinux.org/${package}.git $package &> /dev/null"
end
init "Building"
run "cd /tmp/build/$package ; makepkg &> /dev/null"
end

init "Installing"
pacman -U --noconfirm "/tmp/build/$package/$package"*.pkg.tar.xz &> /dev/null
((errors+=$?))
end

init "Removing source files"
rm --force --recursive /tmp/build
end

if [[ $errors -ne 0 ]]; then
    exit $errors
else
    echo "Package ${package} built and installed from source"
    sleep 5
fi
