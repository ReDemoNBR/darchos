#!/bin/bash

size=$1

clear
echo -e "Creating swapfile with ${size}B size...\n"

function init {
    echo -n "${1}..."
}
function end {
    echo " done"
}

init "Alocating"
fallocate --length "$size" /swapfile &> /dev/null
end
init "Adjusting permissions"
chmod 600 /swapfile &> /dev/null
end
init "Setting up"
mkswap /swapfile &> /dev/null
end
init "Enabling"
swapon /swapfile &> /dev/null
end
init "Adding to fstab so it loads on boot"
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
end

echo "Swapfile created"
sleep 5