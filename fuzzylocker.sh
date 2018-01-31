#!/bin/bash

# Take a screenshot
/usr/bin/import -window root /tmp/screen_locked.png

# Pixellate it 10x
/usr/bin/convert /tmp/screen_locked.png -blur 0x6 /tmp/screen_locked.png

# Lock screen displaying this image.
/usr/bin/i3lock -i /tmp/screen_locked.png

# Turn the screen off after a delay.
sleep 600; pgrep i3lock && xset dpms force off
