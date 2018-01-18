#!/bin/bash

timezone=$1

clear
echo -e "Adjusting localtime to be $( echo $timezone | rev | cut -d '/' -f 1,2 | rev ) timezone...\n"

if [[ -f $timezone ]]; then
    echo -n "Creating symbolic link from $timezone to /etc/localtime... "
    ln --force --symbolic "$timezone" /etc/localtime
    echo "done"
else
    echo "$timezone not found"
    exit 1
fi

echo "Timezone added"
sleep 5