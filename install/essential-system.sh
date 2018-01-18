#!/bin/bash

username=$1
wifi_ssid=$2
wifi_pass=$3

if [[ -n $wifi_ssid && -n $wifi_pass ]]; then
    wifi=1
fi

function install() {
    bash install/pacman-install.sh "$@"
}

function install_aur() {
    bash install/yaourt-install.sh -u "$username" "$@"
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

function daemon() {
    local OPTIND option daemon
    while getopts ":S:s:d:" option; do
        case $option in
            S)
                daemon=$OPTARG >&2
                init "Enabling (but not starting) $daemon service daemon"
                systemctl enable "${daemon}.service" &> /dev/null
                if [[ $? -ne 0 ]]; then
                    echo "Could not enable ${daemon}.service" >> /darchos/errors.txt
                    end "fail"
                else
                    end
                fi
                ;;
            s)
                daemon=$OPTARG >&2
                init "Enabling $daemon service daemon"
                systemctl enable "${daemon}.service" &> /dev/null
                if [[ $? -ne 0 ]]; then
                    echo "Could not enable ${daemon}.service" >> /darchos/errors.txt
                    end "fail"
                    continue
                fi
                systemctl start "${daemon}.service" &> /dev/null
                if [[ $? -ne 0 ]]; then
                    echo "Could not start ${daemon}.service" >> /darchos/errors.txt
                    end "fail"
                    continue
                fi
                end
                ;;
            d)
                daemon=$OPTARG >&2
                init "Disabling $daemon service daemon"
                systemctl stop "${daemon}.service" &> /dev/null
                if [[ $? -ne 0 ]]; then
                    echo "Could not stop ${daemon}.service" >> /darchos/errors.txt
                    end "fail"
                    continue
                fi
                systemctl disable "${daemon}.service" &> /dev/null
                if [[ $? -ne 0 ]]; then
                    echo "Could not disable ${daemon}.service" >> /darchos/errors.txt
                    end "fail"
                    continue
                fi
                end
                ;;
            \?)
                echo "Invalid option -$OPTARG" | tee --append /darchos/errors.txt
                exit 1
                ;;
        esac
    done
}

clear
echo -e "Installing essential system...\n"

# Install customizepkg
install_aur customizepkg
cp --force --recursive /darchos/res/etc/customizepkg.d/* /etc/customizepkg.d
# Install X.org
install xorg-xinit xorg-server xorg-server-common xorg-xrandr xterm
# Install video driver
install mesa xf86-video-vesa xf86-video-fbdev
# Install audio
install alsa-firmware alsa-utils pulseaudio pulseaudio-alsa
# Install desktop environment (Xfce)
install xfce4 xfce4-goodies exo thunar thunar-archive-plugin thunar-media-tags-plugin xdg-utils xdg-user-dirs engrampa parole catfish
install_aur xdg-su mugshot
# Install packages to automount USB
install gvfs udisks2 thunar-volman
# Install display manager (LightDM GTK Greeter)
install lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
# Install network manager
install networkmanager networkmanager-dispatcher-ntpd networkmanager-openvpn networkmanager-openconnect networkmanager-pptp nm-connection-editor network-manager-applet
## Disables Wifi through WPA Supplicant and starts with NetworkManager
daemon -s dhcpcd -s NetworkManager -d "wpa_supplicant@wlan0" -d wpa_supplicant
if [[ -n $wifi ]]; then
    sleep 10
    attempts=10
    until [[ $attempts -eq 0 || -n $( nmcli device wifi | grep $wifi_ssid ) ]]; do
        ((attempts--))
        echo "Did not find SSID $wifi_ssid yet... Searching again..."
        sleep 5
    done
    init "Reconnecting wifi through NetworkManager"
    nmcli device wifi connect $wifi_ssid password $wifi_pass
    if [[ $? -ne 0 ]]; then
        sleep 10
        echo "Could not connect to wifi using networkmanager; SSID=$wifi_ssid ; PASS=$wifi_pass" >> /darchos/errors.txt
        end "fail"
        fi
    sleep 10
    end
else
    nmcli radio wifi off
fi

# Install bluetooth
install blueman bluez bluez-utils
daemon -s bluetooth
# Install Avahi
install avahi nss-mdns
daemon -s avahi-daemon
# Install pamac (graphical interface to manage packages)
install_aur pamac-aur pamac-tray-appindicator
# Syntax highlighting for nano text editor
install_aur nano-syntax-highlighting-git
# Gnome keyrings
install gnome-keyring
# User management GUI
install_aur gnome-system-tools

echo "Essential packages installed"
sleep 5