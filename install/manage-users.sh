#!/bin/bash

## functions
source lib/message.sh
source lib/change-password.sh

## constants
source config.txt

clear
title "Managing users"

init "Removing all existing users with home"
for user in $(cat /etc/passwd | grep /home/ | cut --delimiter ":" --fields 1); do
    prog "deleting $user"
	userdel --remove --force "$user" &> /dev/null
done
end

init "Creating user $USER_NAME"
# Create user in wheel group
useradd --create-home --groups "disk,lp,network,optical,power,scanner,storage,video,wheel" --shell "/bin/bash" "$USER_NAME"
end

init "Creating XDG compliant directories for user $USER_NAME"
su --login "$USER_NAME" --command "cd /home/$USER_NAME ; mkdir Documents Downloads Music Pictures Public Templates Videos"
end

change_password "$USER_NAME" "$USER_PASSWORD"
change_password "root" "$ROOT_PASSWORD"

finish "User managing done"