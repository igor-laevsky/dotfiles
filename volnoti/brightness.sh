#!/bin/bash

icons="
 -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg"

step=5

case "$1" in
  "up")
    xbacklight -inc ${step}
    ;;
  "down")
    xbacklight -dec ${step}
    ;;
esac

volnoti-show ${icons} $(xbacklight -get)
