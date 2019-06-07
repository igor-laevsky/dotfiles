#!/bin/sh

userresources=$HOME/.config/.Xdefaults
usermodmap=$HOME/.config/.Xmodmap

# merge in defaults and keymaps
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Auto screen lock and monitor turn-off
xset s on
xset s 300
xset +dpms
xset dpms 900 900

# HiDpi
xrandr --dpi 240
export GDK_SCALE=2.5
export GDK_DPI_SCALE=0.5
export QT_DEVICE_PIXEL_RATIO=2

# Set up keyboard layout
setxkbmap -model pc105 -layout "us,ru" -option "grp:lctrl_lwin_toggle,ctrl:nocaps"

#exec i3 >~/i3log-$(date +'%F-%k-%M-%S') 2>&1
exec i3
