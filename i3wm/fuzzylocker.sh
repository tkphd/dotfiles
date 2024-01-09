#!/bin/bash
LOCK="${HOME}/.config/i3/lock.png"
BLUR='/tmp/screen_locked.png'
CANV="${HOME}/.config/i3/canvas.png"
PXLS=$(xrandr | /bin/grep '*' | awk '{print $1}')

if [[ -e "${CANV}" ]]; then
    # Superimpose lock icon on canvas
    /usr/bin/convert ${CANV} ${LOCK} -size ${PXLS} -gravity center -composite ${BLUR}

    # Lock screen displaying this image.
    /usr/bin/i3lock -i ${BLUR}

else
    # Take a screenshot
    /usr/bin/import -window root -density 1280x720 -gravity center ${BLUR} || exit

    # Pixellate it
    /usr/bin/convert ${BLUR} -blur 0x8 ${BLUR}

    # Superimpose lock icon
    /usr/bin/convert ${BLUR} ${LOCK} -size ${PXLS} -gravity center -composite ${BLUR}

    # Lock screen displaying this image.
    /usr/bin/i3lock -i ${BLUR}

fi

# # Turn the screen off after 15 min.
# sleep 900; pgrep i3lock && xset dpms force off
