#!/bin/bash

source ./config.txt
clear
echo "Waiting 10 seconds for internet connection to be stabilished..."
# sleeps for 10 seconds so internet connection is setup
sleep 10

# check for errors
bash errors.sh
if [[ $? -ne 0 ]]; then
	exit 1
fi

# disable powersave and TTY from getting blank with user inactivity
setterm -blank 0 -powersave off

## run bash scripts
function run_until_success() {
    install_script=$1
    params=${*:2}
    if [[ ! -f install/${install_script}.sh ]]; then
        echo "Install script ${install_script}.sh not found"
        exit 1
    fi
    while bash install/${install_script}.sh ${params[*]}; [[ $? -ne 0 ]]; do
        echo "Failed in running ${install_script}.sh... Refreshing pacman database and trying again..."
        pacman -Syyu
    done
}

if [[ -n $WIFI_SSID && -n $WIFI_PASS ]]; then
    wifi=1
fi

bash install/prepare.sh "$wifi"
bash install/base-system.sh

# Build yaourt from scratch
run_until_success "raw-build" "package-query"
run_until_success "raw-build" "yaourt"

bash install/hardware-specific.sh

if [[ -n $SWAPFILE_SIZE ]]; then
	bash install/swapfile.sh "$SWAPFILE_SIZE"
fi
if [[ -n $TMP_SIZE ]]; then
	bash install/resize-tmp.sh "$TMP_SIZE"
fi

# Basic Configuration
if [[ -n $KEYBOARD ]]; then
	bash configs/keyboard.sh "$KEYBOARD"
fi
bash configs/timezone.sh "$TIMEZONE"
bash configs/hostname.sh "$HOSTNAME"
bash configs/locales.sh "$LANGUAGE" "${ADDITIONAL_LANGUAGES[*]}"
bash install/manage-users.sh "$ROOT_PASSWORD" "$USER_NAME" "$USER_PASSWORD"


bash install/essential-system.sh "$USER_NAME" "$WIFI_SSID" "$WIFI_PASS"
bash install/util-applications.sh "$USER_NAME" "$LANGUAGE" "${ADDITIONAL_LANGUAGES[*]}"
bash install/themes.sh "$USER_NAME"
bash install/funny-packages.sh "$USER_NAME"

bash install/retry-installation.sh "$USER_NAME"

# Transfer config files
bash install/user-setup.sh "$USER_NAME"
bash install/system-setup.sh

su --login "$USER_NAME" --command "cp --force /darchos/errors.txt /home/$USER_NAME/errors.txt"
bash install/wrapup.sh

clear
echo "Rebooting machine..."
sleep 5

# reboot the machine and everything should be OK
shutdown --reboot now
