#!/bin/bash

## functions
source lib/message.sh

## constants
source conf/darchos.conf
source config.txt


clear
title "Adding general configurations"

subtitle "Configurating keyboard layout"
init "Configurating keyboard to $KEYBOARD_TYPE"
if [[ -f $KEYBOARD_TYPE ]]; then
    loadkeys $KEYBOARD_TYPE
    keymap=${KEYBOARD_TYPE##*/}
    keymap=${keymap%%.*}
    localectl set-keymap $keymap
    end
else
    echo "Couldn't find $KEYBOARD_TYPE layout to load keys" >> $ERROR_FILE
    prog "Couldn't find $KEYBOARD_TYPE layout to load keys"
    end "failed"
fi

subtitle "Configurating timezone"
init "Configurating timezone to $( echo $TIMEZONE | rev | cut --delimiter '/' --fields 1,2 | rev )"
if [[ -f $TIMEZONE ]]; then
    ln --force --symbolic "$TIMEZONE" /etc/localtime
    end
else
    prog "Couldn't find $TIMEZONE file"
    end "failed"
fi

subtitle "Configurating locales"
init "Adding the following locales: $LANGUAGE ${ADDITIONAL_LANGUAGES[*]}"
for lang in $LANGUAGE "${ADDITIONAL_LANGUAGES[@]}"; do
	iso=$(echo "$lang ISO-8859-1")
	utf=$(echo "$lang.UTF-8 UTF-8")
	sed --in-place "s/^#\($iso\)/\1/" /etc/locale.gen
	sed --in-place "s/^#\($utf\)/\1/" /etc/locale.gen
done
end
locale-gen

mainlang=$(echo "${LANGUAGE}.UTF-8")
rm /etc/locale.conf
init "Appending variables to /etc/locale.conf"
for property in LANG LC_TELEPHONE LC_PAPER LC_NUMERIC LC_MONETARY LC_IDENTIFICATION LC_MEASUREMENT LC_ADDRESS LC_NAME LC_TIME LC_CTYPE LC_MESSAGES; do
	echo "${property}=$mainlang" >> /etc/locale.conf
done
end

subtitle "Configurating hostname"
init "Setting name to $HOSTNAME"
hostnamectl set-hostname $HOSTNAME
end

host="127.0.1.1 $HOSTNAME.localdomain"
init "Adding '$host $HOSTNAME' to /etc/hosts"
echo "$host $HOSTNAME" >> /etc/hosts
end

finish "Configurations added"