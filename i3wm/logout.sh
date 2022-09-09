#!/bin/bash
# Manage logout with rofi

option=$(echo -e "suspend\nlock\nlogout\nlogout kde\nreboot\nhalt\nkill-${USER}" | rofi -width 600 -dmenu -p system)

case $option in
    "suspend")
        sudo  /usr/bin/systemctl syspend
        ;;
    "lock")
        i3lock -i "${HOME}/.config/i3/lock.png"
        ;;
    "logout")
        i3-nagbar -t warning -m 'Are you sure you  want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'
        ;;
    'logout kde')
        qdbus-qt5 org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1
        ;;
    "reboot")
        /usr/bin/systemctl reboot
        ;;
    "halt")
        /usr/bin/systemctl poweroff
        ;;
    "kill $USER")
        loginctl kill-user "${USER}"
        ;;
esac
