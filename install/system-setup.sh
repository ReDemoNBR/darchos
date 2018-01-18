#!/bin/bash

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

function copy() {
    init "Copying $1"
    if [[ -d "/darchos/res$1" ]]; then
        init " It's a directory, so copying recursively"
        if [[ ! -d $1 ]]; then
            mkdir --parents "$1"
            init " Needed to create parent directories"
        fi
        cp --force /darchos/res"$1"/* "$1/"
    else
        cp --force "/darchos/res$1" "$1"
    fi
    end
}

function backup() {
    from=$1
    to=$2
    init "Backing up $from"
    cp --force "/darchos/res/$from" "$to"
    end
}

function enable() {
    end "Enabling $1 service"
    systemctl start "${1}.service" &> /dev/null
    systemctl enable "${1}.service" &> /dev/null
    end
}

function root_home() {
    init "Creating .$1 in root's home"
    ## recursive copy if its a directory
    if [[ -d "/darchos/res/user-home/$1" ]]; then
        init " It's a directory, so copying recursively"
        cp --recursive --force "/darchos/res/user-home/$1" "/root/.$1"
    else
        cp --force "/darchos/res/user-home/$1" "/root/.$1"
    fi
    end
}

clear
echo -e "Configurating system...\n"

copy "/etc/nanorc"
copy "/etc/lightdm/lightdm-gtk-greeter.conf"
copy "/usr/share/icons/default/index.theme"
copy "/etc/pamac.conf"
copy "/etc/polkit-1/rules.d/99-darchos.rules"
copy "/etc/nsswitch.conf"

root_home "bash_profile"
root_home "bashrc"
root_home "extend.bashrc"
root_home "dir_colors"
init "Creating .nanorc in root's home"
cp --force /darchos/res/etc/nanorc /root/.nanorc
end

## Add 'hostname.local' hostname resolution according to https://wiki.archlinux.org/index.php/Avahi
init "Configurating avahi"
sed --in-place 's/\(.*\)\(resolve \[!UNAVAIL=return\] dns.*\)/\1mdns_minimal [NOTFOUND=return] \2/' /etc/nsswitch.conf
end

copy "/etc/bash.bashrc"
copy "/etc/sudoers"
backup "/usr/lib/os-release" "/etc/darchos/os-release"
copy "/usr/share/backgrounds/darchos"
copy "/usr/lib/systemd/scripts/darchos.sh"
copy "/usr/lib/systemd/system/darchos.service"
chmod 755 /usr/lib/systemd/scripts/darchos.sh
enable darchos

echo "System configurated"
sleep 5