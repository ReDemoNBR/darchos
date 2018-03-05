#!/bin/bash

## functions
source lib/copy-files.sh
source lib/message.sh

## constants
source conf/darchos.conf
source config.txt

clear
n=$((${#USER_NAME}-1))
if [[ "${USER_NAME:$n:1}" == "s" ]]; then
    title "Configurating ${USER_NAME}' home"
else
    title "Configurating ${USER_NAME}'s home"
fi

subtitle "Copying configuration files"
copy_user "bash_profile"
copy_user "bashrc"
copy_user "extend.bashrc"
copy_user "nanorc"
copy_user "dir_colors"
copy_user "icons"
copy_user "config"
copy_user "tmp.sh"


subtitle "Adding desktop icons to desktop"
desktop_icons=("audacious" "bluefish" "catfish" "chromium" "cpu-g" "dbvis" "dia" "engrampa" "firefox" "galculator" "gcolor2"
               "gimp" "gpick" "libreoffice-startcenter" "libreoffice-calc" "libreoffice-impress" "libreoffice-writer" "mousepad"
               "org.gnome.Calculator" "org.kde.kolourpaint" "org.xfce.Parole" "pamac-manager" "pamac-updater" "pix" "qbittorrent"
               "ristretto" "terminator" "terminology" "thunderbird" "vlc" "xed" "xfce4-terminal" "xplayer" "xreader" "xviewer")

for icon in "${desktop_icons[@]}"; do
    file="/usr/share/applications/${icon}.desktop"
    if [[ -f $file ]]; then
        init "Adding $icon to desktop"
        su --login "$USER_NAME" --command "xdg-desktop-icon install --novendor $file &> /dev/null" &> /dev/null
        end
    else
        echo "Could not find file $file" | tee --append $ERROR_FILE
    fi
done

init "Creating an autostart script for first usage"
script=$(echo -e "\
[Desktop Entry]\n\
Type=Application\n\
Name=Arrange Desktop at first use\n\
Exec=bash /home/$USER_NAME/.tmp.sh")
su --login "$USER_NAME" --command "mkdir --parents /home/${USER_NAME}/.config/autostart"
su --login "$USER_NAME" --command "echo \"$script\" > /home/${USER_NAME}/.config/autostart/arrange.desktop"
end

finish "User setup done"