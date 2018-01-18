#!/bin/bash

username=$1
package=$2

if [[ ! -f "/darchos/res/pkgbuilds/$package" ]]; then
    echo "Local PKGBUILD source for $package not found"
    exit 1
fi

## Use a local-provided PKGBUILD for this package
su --login "$username" --command "mkdir --parents /tmp/build/$package ; \
    cp /darchos/res/pkgbuilds/$package /tmp/build/$package/PKGBUILD ; \
    cd /tmp/build ; yaourt -P --noconfirm $package ; \
    yaourt -U --noconfirm $package/$package*.pkg.tar.xz ; \
    cd /home/$username ; rm --force --recursive /tmp/build"
