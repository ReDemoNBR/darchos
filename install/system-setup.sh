#!/bin/bash

## functions
source lib/copy-files.sh
source lib/daemon-control.sh
source lib/message.sh

clear
title "Configurating system"

subtitle "Copying system config files"
copy "/etc/nanorc"
copy "/etc/lightdm/lightdm-gtk-greeter.conf"
copy "/usr/share/icons/default/index.theme"
copy "/etc/pamac.conf"
copy "/etc/polkit-1/rules.d/99-darchos.rules"
copy "/etc/nsswitch.conf"
copy "/etc/bash.bashrc"
copy "/etc/sudoers"
copy "/usr/lib/os-release" "/etc/darchos/os-release"
copy "/usr/share/backgrounds/darchos"
# copy "/usr/lib/systemd/scripts/darchos.sh"
# copy "/usr/lib/systemd/system/darchos.service"
chmod 755 /usr/share/libalpm/scripts/update-os-release.sh

subtitle "Copying root config files"
copy_root "bash_profile"
copy_root "bashrc"
copy_root "extend.bashrc"
copy_root "dir_colors"
copy_root "/etc/nanorc" "nanorc"

## Add 'hostname.local' hostname resolution according to https://wiki.archlinux.org/index.php/Avahi
init "Configurating avahi"
sed --in-place 's/\(.*\)\(resolve \[!UNAVAIL=return\] dns.*\)/\1mdns_minimal [NOTFOUND=return] \2/' /etc/nsswitch.conf
end

# chmod 755 /usr/lib/systemd/scripts/darchos.sh
# daemonctl -E darchos

finish "System setup done"