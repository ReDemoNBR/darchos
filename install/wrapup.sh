#!/bin/bash

clear
echo -e "Finishing installation...\n"

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

init "Copying useful DArchOS files to /etc/darchos"
## transfer user home standard configs
mkdir --parents /etc/darchos/userconf
cp --recursive --force "/darchos/res/user-home" "/etc/darchos/userconf"
end

init "Copying installation error log file to /etc/darchos"
cp --force "/darchos/errors.txt" "/etc/darchos/errors-on-install.log"
end

init "Backing up os-release"
cp /darchos/res/usr/lib/os-release /etc/darchos/os-release
end

init "Disabling auto-run of first-boot script"
rm --force --recursive "/etc/systemd/system/getty@tty1.service.d"
cp --force "/darchos/res/etc/systemd/logind.conf" "/etc/systemd/logind.conf"
end

init "Removing DArchOS installation files"
rm --force --recursive "/darchos"
end

init "Enabling lightdm service"
systemctl enable lightdm.service &> /dev/null
end

echo "Installing done..."
sleep 5