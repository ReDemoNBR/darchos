#!/bin/bash

## functions
source lib/yaourt.sh
source lib/message.sh

## constants
source conf/darchos.conf

clear

init "Checking if any installed package was updated in the mean time"
update_aur
end

subtitle "Checking if any of the packages was not installed in order to try again now"
if [[ ! -f $PACKAGES_FILE ]]; then
    echo "Could not find $PACKAGES_FILE file when trying to find packages that were not installed" | tee --append $ERROR_FILE
    exit 1
fi

while read -r package; do
    if [[ -z $( pacman -Qqs ^${package}$ ) ]]; then
        echo "Retrying to install ${package} using yaourt"
        refresh_aur
        install_aur $package
        if [[ $? -ne 0 ]]; then
            echo "Retried unsuccessfully to install package $package with yaourt" | tee --append $ERROR_FILE
            echo "$package" >> $FAILED_PACKAGES_FILE
        fi
    fi
done < $PACKAGES_FILE

init "Removing list of packages as they all were installed"
rm $PACKAGES_FILE
end

if [[ ! -f $FAILED_PACKAGES_FILE || -z $( cat $FAILED_PACKAGES_FILE ) ]]; then
    rm $FAILED_PACKAGES_FILE
    finish "All packages correctly installed"
else
    echo "This is the list of packages that could not be installed"
    cat $FAILED_PACKAGES_FILE
    finish "These were the packages that could not be installed\nYou should be able to find this file in $FAILED_PACKAGES_FILE_AFTER"
fi
