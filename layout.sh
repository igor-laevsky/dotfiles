#!/bin/bash

case "$1" in
  single)
    xrandr --output HDMI-0 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --scale 0.5 --filter nearest
    ;;

  dual-1200)
    xrandr --fb 3840x1200 --output HDMI-0 --mode 1920x1200 --pos 1920x0 --rotate normal --output DP-2 --mode 3840x2160 --pos 0x120 --rotate normal --scale 0.5 --filter nearest
    ;;
esac

