#!/bin/bash

username=$1
languages=${*:2}

function install() {
    bash install/pacman-install.sh "$@"
}

function install_aur() {
    bash install/yaourt-install.sh -u "$username" "$@"
}

function check_install() {
    if [[ -n $( pacman -Sqs ^${1}$ ) ]]; then
        install $1
    fi
}

function check_install_aur() {
    package=$( yaourt -Sqs $1 )
    if [[ -n $package && "$package" == "$1" ]]; then
        install_aur $1
    fi
}


clear
echo -e "Installing util applications...\n"

# Applications from X-Apps Project
install xapps xreader
install_aur "xplayer-plparser" "xplayer" "xviewer" "xviewer-plugins" "xed" "pix"

# Browser
install chromium firefox
## Install languages i18n packages for firefox
echo "Searching and installing firefox language packs..."
for language in $languages; do
    ## tests for firefox-i18n-pt-br (using 'pt_BR' locale as example)
    check_install "firefox-i18n-$(echo "${language,,}" | sed 's/_/\-/g' )"
done

# Media player
## Codecs/plugins
install x264 x265 gstreamer gst-plugins-base gst-plugins-base-libs gst-plugins-bad gst-plugins-good gst-plugins-ugly
## Player
install audacious audacity vlc

# Calculator
install galculator gnome-calculator

# Image
install gimp graphicsmagick imagemagick inkscape kolourpaint
echo "Searching and installing gimp language packs..."
for language in $languages; do
    ## tests for gimp-help-pt_br and gimp-help-pt (using 'pt_BR' locale as example)
    check_install "gimp-help-${language,,}"
    check_install "gimp-help-$(echo ${language,,} | cut --delimiter '_' --fields 1)"
done

# Office
install libreoffice-fresh
install_aur libreoffice-extension-languagetool
echo "Searching and installing libreoffice-fresh language packs..."
for language in $languages; do
    ## tests for libreoffice-fresh-pt-BR and libreoffice-fresh-pt (using 'pt_BR' locale as example)
    check_install "libreoffice-fresh-$(echo $language | sed 's/_/-/g')"
    check_install "libreoffice-fresh-$( echo $language | cut --delimiter '_' --fields 1 )"
done

# Terminal emulator
install terminator terminology

# Color picker
install gcolor2 gpick

# Mail reader
install thunderbird
echo "Searching and installing thunderbird language packs..."
for language in $languages; do
    ## tests for thunderbird-i18n-pt-BR (using 'pt_BR' locale as example)
    check_install "thunderbird-i18n-$( echo "${language,,}" | sed 's/_/\-/g' )"
done

# Torrent
install qbittorrent

## JDK/JRE
install jdk9-openjdk jre9-openjdk jre9-openjdk-headless

# Development
install bluefish dia
install_aur dbvis
install_aur micro-git
echo "Searching and installing vim language packs..."
for language in $languages; do
    ## tests for vim-spell-pt (using 'pt_BR' locale as example)
    check_install "vim-spell-$( echo ${language,,} | cut --delimiter '_' --fields 1 )"
done

# Utils
install hdparm htop screenfetch gparted parted
install_aur neofetch cpu-g-bzr

# Aspell, hunspell and hyphen
install aspell
echo "Searching and installing aspell language packs..."
for language in $languages; do
    ## tests for aspell-pt (using 'pt_BR' locale as example)
    check_install_aur "aspell-$( echo $language | cut --delimiter '_' --fields 1)"
done
install hunspell
echo "Searching and installing hunspell language packs..."
for language in $languages; do
    ## tests for hunspell-pt_BR, hunspell-pt-br, hunspell-pt_br and hunspell-pt (using 'pt_BR' locale as example)
    check_install_aur "hunspell-$language"
    check_install_aur "hunspell-$( echo ${language,,} | sed 's/_/\-/g' )"
    check_install_aur "hunspell-$( echo ${language,,} )"
    check_install_aur "hunspell-$( echo ${language,,} | cut --delimiter '_' --fields 1 )"
done
install hyphen
echo "Searching and installing hyphen language packs..."
for language in $languages; do
    ## tests for hyphen-pt-br and hyphen-pt (using 'pt_BR' locale as example)
    check_install_aur "hyphen-$( echo ${language,,} | sed 's/_/\-/g' )"
    check_install_aur "hyphen-$( echo ${language,,} | cut --delimiter '_' --fields 1 )"
done

# Usefool tools from ArchStrike repository
install blindsql domainanalyzer flashlight

echo "Util applications installed"
sleep 5