#!/bin/bash

username=$1

clear

function init() {
    echo -n "${1}..."
}
function end() {
    if [[ -n $1 ]]; then
        echo " $1"
    else
        echo " done"
    fi
}

init "Checking if any installed package was updated in the mean time"
su --login "$username" --command "yaourt -Syua --noconfirm &> /dev/null" &> /dev/null
end

echo -e "Checking if any of the packages was not installed in order to try again now...\n"
if [[ ! -f /darchos/packages.txt ]]; then
    echo "Could not find /darchos/packages.txt file when trying to find packages that were not installed" | tee --append /darchos/errors.txt
    exit 1
fi

while read -r package; do
    if [[ -z $( pacman -Qqs ^${package}$ ) ]]; then
        init "Retrying to install ${package} using yaourt"
        su --login "$username" --command "yaourt -Sy --noconfirm $package &> /dev/null"
        if [[ $? -ne 0 ]]; then
            echo ""
            end "Retried unsuccessfully to install package $package with yaourt" | tee --append /darchos/errors.txt
        else
            end
        fi
    fi
done < /darchos/packages.txt

init "Removing list of packages as they all were installed"
rm /darchos/packages.txt
end
sleep 5