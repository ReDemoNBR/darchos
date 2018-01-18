#!/bin/bash

rootpasswd=$1
username=$2
userpasswd=$3

function change_pw() {
    user=$1
    password=$2
    bash install/change-passwd.sh "$user" "$password"
}

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

clear
echo -e "Managing users...\n"

echo "Removing all users with home..."
for user in $(cat /etc/passwd | grep /home/ | cut --delimiter ":" --fields 1); do
    init "Deleting user $user"
	userdel --remove --force "$user" &> /dev/null
    end
done

init "Creating user $username"
# Create user in wheel group
useradd --create-home --gid users --groups disk,lp,network,optical,power,scanner,storage,video,wheel --shell /bin/bash "$username"
end

init "Creating XDG compliant directories for user $username"
su --login "$username" --command "cd /home/$username ; mkdir Documents Downloads Music Pictures Public Templates Videos"
end

bash install/change-passwd.sh "$username" "$userpasswd"

bash install/change-passwd.sh "root" "$rootpasswd"

echo "User managing done"
sleep 5