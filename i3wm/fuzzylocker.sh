#!/bin/bash
LOCK="${HOME}/.config/i3/lock.png"
BLUR='/tmp/screen_locked.png'

# Take a screenshot
/usr/bin/import -window root "${BLUR}"

# Pixellate it 10x
/usr/bin/convert "${BLUR}" -blur 0x8 "${BLUR}"

# Superimpose lock icon
/usr/bin/convert "${BLUR}" "${LOCK}" -gravity center -composite "${BLUR}"

# Lock screen displaying this image.
/usr/bin/i3lock -i "${BLUR}"

# Turn the screen off after 15 min.
sleep 900; pgrep i3lock && xset dpms force off
