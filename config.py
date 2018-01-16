#!/usr/bin/python3
# -*- coding: utf-8 -*-

from i3pystatus import Status
from os import environ, getlogin

# Create "ifce.py" in this directory with key-value pairs, e.g.
# ifce = "eth0"
# to feed local machine configuration variables into this script
try:
    from ifce import *
except:
    ifce = "eth0"

home = environ['HOME']
user = getlogin()
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

status.register("disk",
    path="/data/{0}/".format(user),
    hints={'markup': 'pango'},
    format="<span size=\"x-small\"></span> {avail}G",
)
status.register("disk",
    path="/home/",
    hints={'markup': 'pango'},
    format="<span size=\"small\"></span> {avail}G",
)
status.register("disk",
    path="/",
    hints={'markup': 'pango'},
    format="<span size=\"small\"></span> {avail}G",
)

## Shows pulseaudio default sink volume
## Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="♪ {volume}",
)

## Shows alsaaudio default sink volume
## Note: requires pyalsaaudio from PyPI
##       and libalsaaudio-dev
#status.register("alsa",)

# Shows the address and up/down state of eth0. If it is up the address is
# shown in green (the default value of color_up) and the CIDR-address is
# shown (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    # interface="{0}".format(ifce),
    interface=ifce,
    hints={'markup': 'pango'},
    format_up="↘ {bytes_recv}k ↗ {bytes_sent}k",
)

status.run()
