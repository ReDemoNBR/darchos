#!/bin/bash

## functions
source lib/pacman.sh
source lib/yaourt.sh
source lib/message.sh

## constants
source config.txt

languages=("$LANGUAGE")
languages+=("${ADDITIONAL_LANGUAGES[@]}")

function install_langs() {
    subtitle "Installing language packs for ${2:-$1}"
    search_language_packs -n $1 -L "${languages[*]}"
}

clear
title "Installing util applications"

# Applications from X-Apps Project
install xapps xreader
install_aur xplayer-plparser xplayer xviewer xviewer-plugins xed pix

# Browser
install chromium firefox
install_langs firefox-i18n firefox

# Media player
## Codecs/plugins
install ffmpeg lame gstreamer gst-plugins-base gst-plugins-base-libs gst-plugins-bad gst-plugins-good gst-plugins-ugly x264 x265 xvidcore
install jasper libjpeg-turbo libjpeg6-turbo mjpegtools openjpeg openjpeg2 libpng optipng
## Player
install audacious vlc

# Calculator
install galculator gnome-calculator

# Image
install gimp graphicsmagick imagemagick kolourpaint
install_langs gimp-help gimp

## JDK/JRE
install jdk9-openjdk jre9-openjdk jre9-openjdk-headless

# Office
install libreoffice-fresh
install_aur libreoffice-extension-languagetool
install_langs libreoffice-fresh

# Terminal emulator
install terminator terminology

# Color picker
install gcolor2 gpick

# Mail reader
install thunderbird
install_langs thunderbird-i18n thunderbird

# Torrent
install qbittorrent

# Development
install bluefish dia nodejs npm
install_aur dbvis
install_aur micro-git
install_langs vim-spell vim

# Utils
install hdparm htop screenfetch gparted parted linux-tools neofetch
install_aur cpu-g-bzr

# Aspell, hunspell and hyphen
install aspell
install_langs aspell
install hunspell
install_langs hunspell
install hyphen
install_langs hyphen

finish "Util applications installed"