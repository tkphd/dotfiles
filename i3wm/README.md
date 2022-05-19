# i3 window manager

Tiling is cool. Functioning X apps is also cool. Try following
[Ryan Lue's Guide](https://www.ryanlue.com/posts/2019-06-13-kde-i3)
to get i3 working in top of Plasma.

## Prerequisites

Ensure Plasma is installed:

``` bash
dpkg -s plasma-workspace
```

> _N.B.:_`plasma-desktop` should _not_ be installed! 

## Configure i3 for Plasma

Add the following to your i3 config (`~/.config/i3/config`):

``` bash
# Don’t treat Plasma pop-ups as full-sized windows
for_window [class="plasmashell"] floating enable

# Don’t spawn an empty window for the Plasma Desktop
for_window [title="Desktop — Plasma"] kill, floating enable, border none

# Don’t let notifications and non-interactive pop-up windows steal focus
no_focus [class="plasmashell" window_type="notification"]
no_focus [class="plasmashell" window_type="on_screen_display"]
```

## Configure a login screen entry

Normally, KDE launches with `$KDEWM` set to whatever tf.

1. Create a Plasma+i3 launcher

   ```bash /usr/local/bin/startplasma-i3
   #!/bin/sh
   export KDEWM=/usr/bin/i3
   /usr/bin/startplasma-x11
   ```
  
2. Create a custom desktop file

   ```shell
   sudo cp /usr/share/xsessions/plasma.desktop \
           /usr/share/xsessions/plasma-i3.desktop
   ```

3. Make it right:

   ```bash /usr/share/xsessions/plasma-i3.desktop
   [Desktop Entry]
   Type=XSession
   Exec=/usr/local/bin/startplasma-i3
   TryExec=/usr/local/bin/startplasma-i3
   DesktopNames=KDE
   Name=Plasma-i3
   Comment=Plasma ❤ i3
   X-KDE-PluginInfo-Version=5.20.5
   ```

## Try it!

Log out, and the new Plasma-i3 option should be available?
