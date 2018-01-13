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

# Disable monitor power saving
xset s off
xset -dpms

#exec i3 >~/i3log-$(date +'%F-%k-%M-%S') 2>&1
exec i3
