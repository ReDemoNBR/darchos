#!/bin/bash

username=$1
source=$2
package=$3

## Download and alter "source" property in PKGBUILD
su --login "$username" --command "mkdir -p /tmp/build ; cd /tmp/build ; \
	yaourt -G $package ; sed --in-place \"s/^source=.*/source=('$source')/\" $package/PKGBUILD ; \
	yaourt -P --noconfirm $package ; yaourt -U --noconfirm $package/$package*.pkg.tar.xz ; \
	cd /home/$username ; rm --force --recursive /tmp/build"