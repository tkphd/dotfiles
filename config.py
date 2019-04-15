#!/usr/bin/python3
# -*- coding: utf-8 -*-

from i3pystatus import Status
from os import environ

# Create "machine.py" in this directory with key-value pairs, e.g.
#    ifce = "eth0"
#    disks = [["/", ""], ["/home", ""], ["/data", ""]]
# to feed local machine configuration variables into this script
try:
    from machine import *
except:
    # Defaults! Renders a penguin for '' and a house for '' (Font Awesome)
    ifce = "eth0"
    disks = [["/", ""], ["/home", ""]]

home = environ['HOME']
status = Status()

# Use pango markup to modify fonts per item. Valid font sizes are
# 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large'

# Displays clock like this:
# Tue 30 Jul 11:59 PM
status.register("clock",
                format="%a %-d %b %I:%M %p",
)

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load")

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
                format="{temp:.0f}°C",
)

# Shows disk usage of /
# Format:
# 42/128G [86G]
for disk, icon in disks:
    status.register("disk",
                    path=disk,
                    hints={'markup': 'pango'},
                    format="<span size=\"x-small\">%s</span> {avail}G"%icon,
    )

try:
    ## Shows pulseaudio default sink volume
    ## Note: requires libpulseaudio from PyPI
    status.register("pulseaudio",
                    format="♪ {volume}",
    )
except:
    ## Shows alsaaudio default sink volume
    ## Note: requires pyalsaaudio from PyPI
    ##       and libalsaaudio-dev
    status.register("alsa")

# Battery status
status.register("battery",
                format="{status} {consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
                alert=True,
                alert_percentage=5,
                status={
                    "DIS": "↓",
                    "CHR": "↑",
                    "FULL": "=",
                },)

# Shows the address and up/down state of eth0. If it is up the address is
# shown in green (the default value of color_up) and the CIDR-address is
# shown (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
                interface=ifce,
                hints={'markup': 'pango'},
                format_up="↘ {bytes_recv}k ↗ {bytes_sent}k",
)

status.run()
