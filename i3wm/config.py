#!/usr/bin/env python3
# General layout of the i3 bar

# To feed local machine configuration variables into this script,
# create "machine.py" in this directory with key-value pairs, e.g.
#
#    ifce = "eth0"
#    disks = [["/data", ""], ["/home", ""], ["/", ""]]
#    battery = False
#
# Use pango markup to modify fonts per item. Valid font sizes are
# 'xx-small', 'x-small', 'small', 'medium', 'large', 'x-large', 'xx-large'

import i3pystatus
from os import environ, path, stat

colors = {
    "blue":        "#0000ff",
    "green":       "#00ff00",
    "gray58":      "#949494",
    "graygreen":   "#a2a899",
    "greenseas":   "#cbd2c0",
    "palegraygr":  "#dadfd2",
    "ghostviolet": "#f6f6ff",
    "ghostwhite":  "#f8f8ff",
    "cottonball":  "#fafaff",
    "red":         "#ff0000",
    "strawberry":  "#ff4444",
    "towsonyell":  "#ffcc00",
    "lightyellow": "#ffee44",
    "yellow1":     "#ffff00",
    "white":       "#ffffff",
}

icons = {
    'default':       ('‽', None),
    'Cloudy':        ('☁', None),  # 'ghostwhite'
    'Fair':          ('☀', None),  # 'towsonyell'
    'Fog':           ('⛆', None),  # 'gray58'
    'Hail Storm':    ('🌨', None),  # 'graygreen'
    'Light Rain':    ('🌦', None),  # 'palegraygr'
    'M Cloudy':      ('☁', None),  # 'ghostviolet'
    'Mostly Sunny':  ('🌤', None),  # 'yellow1'
    'Overcast':      ('☁', None),  # 'ghostviolet'
    'P Cloudy':      ('🌥', None),  # 'cottonball'
    'Partly Cloudy': ('🌥', None),  # 'cottonball'
    'Rain':          ('🌧', None),  # 'greenseas'
    'Rainy':         ('🌧', None),  # 'greenseas'
    'Rain Shower':   ('🌦', None),  # 'palegreygr'
    'Snow':          ('❄', None),  # 'white'
    'Sunny':         ('✶', None),  # 'yellow1'
    'Thunderstorm':  ('⛈', None),  # 'graygreen'
    'Tornado':       ('🌪', colors["red"])
}

try:
    from machine import ifce, disks, battery, excludes
except ImportError:
    # Defaults render a penguin '' for '/'
    # and a house '' for /home (Font Awesome)
    ifce = "eth0"
    disks = [["/home", "", "GB"],
             ["/",     "", "GB"]]
    battery = False

home = environ["HOME"]
status = i3pystatus.Status()


status.register(
    "clock",
    format="%a %-d %b %I:%M %p",  # Tue 30 Jul 11:59 PM
)

if "pomodoro" not in excludes:
    try:
        status.register(
            "pomodoro",
            pomodoro_duration=3000,
            break_duration=600,
            long_break_duration=1800,
            short_break_count=2,
            inactive_format="🍅",
            format="🍅 {current_pomodoro}/{total_pomodoro} {time}",
            hints={"markup": "pango"},
        )
    except i3pystatus.core.exceptions.ConfigKeyError:
        pass

for disk, icon, unit in disks:
    # Format: " 2.015 TB"
    denom = 1024**4 if unit == "TB" else 1024**3
    place = 3 if unit == "TB" else 1
    status.register(
        "disk",
        path=disk,
        hints={"markup": "pango"},
        divisor=denom,
        round_size=place,
        format='<span size = "x-small">%s</span> {avail} %s' % (icon, unit),
    )

if "weather" not in excludes:
    try:
        from i3pystatus.weather import wunderground
        status.register(
            'weather',
            format='{condition} [{icon} ] {feelslike} {temp_unit}, {humidity}% 🌢[ {update_error}]',
            color_icons=icons,
            colorize=True,
            hints={'markup': 'pango'},
            backend=wunderground.Wunderground(
                location_code='KMDGERMA56',
                units='metric',
                update_error='<span color="#ff1111">!</span>',
            ),
        )
    except ImportError:
        pass
    except i3pystatus.core.exceptions.ConfigKeyError:
        pass
    except i3pystatus.core.exceptions.ConfigMissingError:
        pass

try:
    # Shows pulseaudio default sink volume
    # Note: requires libpulseaudio from PyPI
    status.register(
        "pulseaudio",
        format="♪ {volume}",
        # sink="combined",
        multi_colors=True,
        hints={"markup": "pango"},
    )
except i3pystatus.core.exceptions.ConfigKeyError:
    pass
except ImportError:
    # Shows alsaaudio default sink volume
    # Note: requires pyalsaaudio from PyPI
    #       and libalsaaudio-dev
    status.register("alsa")

# Shows memory usage
status.register(
    "mem_bar",
    color=colors["white"],
    warn_color=colors["lightyellow"],
    alert_color=colors["strawberry"],
    hints={"markup": "pango"},
    warn_percentage=80,
    alert_percentage=90,
    multi_colors=True,
    format="{used_mem_bar}",
)

# Plots the average load of the last 5 minutes
status.register(
    "cpu_usage_graph",
    cpu="usage",
    hints={"markup": "pango"},
    graph_width=25,
    format="{cpu_graph} ",
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
    graph_width=25,
    hints={"markup": "pango"},
    format_up="↘ {bytes_recv}k ↗ {bytes_sent}k",
)

status.run()
