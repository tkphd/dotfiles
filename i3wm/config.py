# -*- coding: utf-8 -*-

### Notice:
# To feed local machine configuration variables into this script,
# create "machine.py" in this directory with key-value pairs, e.g.
#
#    ifce = "eth0"
#    disks = [["/data", ""], ["/home", ""], ["/", ""]]
#    battery = False
#
# Use pango markup to modify fonts per item. Valid font sizes are
# 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large'

from i3pystatus import Status
from os import environ, path, stat

try:
    from machine import *
except:
    # Defaults render a penguin '' for '/'
    # and a house '' for /home (Font Awesome)
    ifce = "eth0"
    disks = [["/home", ""],
             ["/", ""]]
    battery = False

home = environ["HOME"]
status = Status()

# Displays clock like this:
# Tue 30 Jul 11:59 PM
status.register(
    "clock",
    format="%a %-d %b %I:%M %p",
)

# Notify when reboot is required
if (
    path.isfile("/var/run/reboot-required")
    and stat("/var/run/reboot-required").st_size != 0
):
    status.register("text",
                    text="reboot me",
                    hints={"markup": "pango"},
                    color="red")

# Shows available disk space
# Format: 2.015 TB
for disk, icon in disks:
    status.register(
        "disk",
        path=disk,
        hints={"markup": "pango"},
        divisor=1024.0 ** 4,
        round_size=3,
        format='<span size = "x-small">%s</span> {avail} TB' % icon,
    )

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
                hints={"markup": "pango"})

# Shows memory usage
status.register(
    "mem_bar",
    color="#FFFFFF",
    hints={"markup": "pango"},
    multi_colors=True,
    format="{used_mem_bar}",
)

try:
    ## Shows pulseaudio default sink volume
    ## Note: requires libpulseaudio from PyPI
    status.register(
        "pulseaudio",
        format="♪ {volume}",
        hints={"markup": "pango"},
    )
except:
    ## Shows alsaaudio default sink volume
    ## Note: requires pyalsaaudio from PyPI
    ##       and libalsaaudio-dev
    status.register("alsa")

# Plots the average load of the last 5 minutes
status.register(
    "cpu_usage_graph",
    cpu="usage",
    hints={"markup": "pango"},
    graph_width=60,
    format="{cpu_graph}",
)

# Battery status
if battery:
    status.register(
        "battery",
        format="{status} {consumption:.2f}W {percentage:.2f}% {remaining:%E%hh:%Mm}",
        alert=True,
        alert_percentage=5,
        status={"DIS": "↓", "CHR": "↑", "FULL": " = ",},
    )

# Shows the address and up/down state of eth0. If it is up the address is
# shown in green (the default value of color_up) and the CIDR-address is
# shown (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register(
    "network",
    interface=ifce,
    hints={"markup": "pango"},
    format_up="↘ {bytes_recv}k ↗ {bytes_sent}k",
)

status.run()
