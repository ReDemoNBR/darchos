#!/bin/bash

langs=("$@")

clear
echo -e "Adding the following languages/locales: ${langs[*]}...\n\n"

function init() {
    echo -n "${1}..."
}
function end() {
    echo " done"
}

# uncomment selected languages in /etc/locale.gen
for lang in ${langs[*]}; do
	iso=$(echo "$lang ISO-8859-1")
	utf=$(echo "$lang.UTF-8 UTF-8")

    init "Adding $iso"
	sed --in-place "s/^#\($iso\)/\1/" /etc/locale.gen
    end

    init "Adding $utf"
	sed --in-place "s/^#\($utf\)/\1/" /etc/locale.gen
    end
done

# generate the locales
locale-gen


# add the main locale to /etc/locale.conf
mainlang=$(echo "$1.UTF-8")
rm /etc/locale.conf
echo "Appending variables to /etc/locale.conf"
for property in LANG LC_TELEPHONE LC_PAPER LC_NUMERIC LC_MONETARY LC_IDENTIFICATION LC_MEASUREMENT LC_ADDRESS LC_NAME LC_TIME; do
    echo " ${property}=$mainlang"
	echo "${property}=$mainlang" >> /etc/locale.conf
done

echo "Languages/locales added"
sleep 5