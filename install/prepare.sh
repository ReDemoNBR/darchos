#!/bin/bash

wifi=$1

clear
echo -e "Preparing system to install...\n"

function install() {
    bash install/pacman-install.sh "$@"
}

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

if [[ -z $wifi ]]; then
    systemctl stop wpa_supplicant.service &> /dev/null
    systemctl disable wpa_supplicant.service &> /dev/null
fi

init "Creating symbolic link for os-release"
ln --force --symbolic "/usr/lib/os-release" "/etc/os-release" &> /dev/null
end

init "Creating list of packages that will attempt to install"
touch /darchos/packages.txt
end

init "Initializing pacman"
pacman-key --init &> /dev/null
pacman -Syy &> /dev/null
end



init "Ranking best mirrors"
# Use best mirrors
pacman -S --force --noconfirm pacman-mirrorlist &> /dev/null
cp --force /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
cp --force /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.tmp
## Uncomment all mirrors
sed --in-place '/Server = /s/^#\s*//g' /etc/pacman.d/mirrorlist.tmp
## Remove all commented lines
sed --in-place '/^#/ d' /etc/pacman.d/mirrorlist.tmp
## Remove GeoIP in order to rank mirrors without it
sed --in-place '/^Server = http:\/\/mirror.archlinuxarm.org/ d' /etc/pacman.d/mirrorlist
rankmirrors -n 0 /etc/pacman.d/mirrorlist.tmp > /etc/pacman.d/mirrorlist
## Re-add GeoIP as last resort for pacman mirrors
echo 'Server = http://mirror.archlinuxarm.org/$arch/$repo' >> /etc/pacman.d/mirrorlist
pacman -Syy &> /dev/null
rm /etc/pacman.d/mirrorlist.tmp
end

echo "Adding ArchStrike repository..."
if [[ -z $( cat /etc/pacman.conf | grep archstrike-mirrorlist ) && -z $( pacman -Qqs archstrike-keyring ) && -z $( pacman -Qqs archstrike-mirrorlist ) ]]; then
    if [[ -z $( cat /etc/pacman.conf | grep archstrike ) ]]; then
        echo -n "Setting up temporary mirror for ArchStrike repository... "
        echo -e '\n[archstrike]\nServer = https://mirror.archstrike.org/$arch/$repo' >> /etc/pacman.conf
        echo "done"
    fi
    archstrike_key="9D5F1C051D146843CDA4858BDE64825E7CBC0D51"
    pacman -Syy &> /dev/null
    pacman-key --init &> /dev/null
    dirmngr < /dev/null &> /dev/null
    echo "Setting up archstrike keys"
    pacman-key --recv-keys "$archstrike_key" &> /dev/null
    pacman-key --lsign-key "$archstrike_key" &> /dev/null
    echo -e "Installing archstrike needed packages"
    install archstrike-keyring
    install archstrike-mirrorlist
    echo -e "Adding ArchStrike repository permanently"
    sed --in-place '/^Server = http:\/\/mirror.archstrike.org/ d' /etc/pacman.conf
    echo 'Include = /etc/pacman.d/archstrike-mirrorlist' >> /etc/pacman.conf
    pacman -Syy &> /dev/null
    echo "Adding ArchStrike repository... done"
else
    echo "Adding ArchStrike repository... not needed (already done)" | tee --append /darchos/errors.txt
fi

init "Adding Xyne-any repository"
if [[ -z $( cat /etc/pacman.conf | grep xyne-any ) ]]; then
    echo -e "\n[xyne-any]\nServer = https://xyne.archlinux.ca/repos/xyne/" >> /etc/pacman.conf
    pacman -Syy &> /dev/null
    end
else
    end "not needed (already done)"
    echo "Xyne-any already added to /etc/pacman.conf" >> /darchos/errors.txt
fi

echo "Preparing done"
sleep 5