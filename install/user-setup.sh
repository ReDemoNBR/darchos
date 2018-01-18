#!/bin/bash

username=$1

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

function copy() {
    init "Creating .$1"
    ## recursive copy if its a directory
    if [[ -d "/darchos/res/user-home/$1" ]]; then
        init " It's a directory, so copying recursively"
        su --login "$username" --command "cp --recursive --force \"/darchos/res/user-home/$1\" \"/home/${username}/.$1\""
    else
        su --login "$username" --command "cp --force \"/darchos/res/user-home/$1\" \"/home/${username}/.$1\""
    fi
    end
}



clear
echo -e "Configurating ${username}'s home...\n"

echo "Copying configuration files..."
copy "bash_profile"
copy "bashrc"
copy "extend.bashrc"
copy "nanorc"
copy "dir_colors"
copy "icons"
copy "config"
copy "tmp.sh"


echo "Adding desktop icons to desktop..."
## Adding icons/launchers/shortcuts to desktop
desktop_icons=("audacious" "audacity" "bluefish" "catfish" "chromium" "cpu-g" "dbvis" "dia" "engrampa" "firefox" "galculator" "gcolor2"
               "gimp" "gpick" "inkscape" "libreoffice-startcenter" "libreoffice-calc" "libreoffice-impress" "libreoffice-writer" "mousepad"
               "org.gnome.Calculator" "org.kde.kolourpaint" "org.xfce.Parole" "pamac-manager" "pamac-updater" "pix" "qbittorrent"
               "ristretto" "terminator" "terminology" "thunderbird" "vlc" "xed" "xfce4-terminal" "xplayer" "xreader" "xviewer")

for icon in "${desktop_icons[@]}"; do
    file="/usr/share/applications/${icon}.desktop"
    if [[ -f $file ]]; then
        init "Adding $icon to desktop"
        su --login "$username" --command "xdg-desktop-icon install --novendor $file &> /dev/null" &> /dev/null
        end
    else
        echo "Could not find file $file" | tee --append /darchos/errors.txt
    fi
done

init "Creating an autostart script for first usage"
su --login "$username" --command "echo [Desktop Entry] > /home/${username}/.config/autostart/arrange.desktop"
su --login "$username" --command "echo Type=Application >> /home/${username}/.config/autostart/arrange.desktop"
su --login "$username" --command "echo Name=Arrange Desktop at first use >> /home/${username}/.config/autostart/arrange.desktop"
su --login "$username" --command "echo Exec=bash /home/${username}/.tmp.sh >> /home/${username}/.config/autostart/arrange.desktop"
end


echo "User setup done"
sleep 5