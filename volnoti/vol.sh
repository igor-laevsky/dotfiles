#!/bin/bash

icons="
 -0 /home/igor/.config/volnoti/icons/mute.svg
 -1 /home/igor/.config/volnoti/icons/off.svg
 -2 /home/igor/.config/volnoti/icons/down.svg
 -3 /home/igor/.config/volnoti/icons/down.svg
 -4 /home/igor/.config/volnoti/icons/up.svg"

scale=2
vol=$(($(pamixer --get-volume)/${scale}))

step=10

case "$1" in
  "up")
    [[ ${vol} -lt 100 ]] && pamixer --allow-boost -i ${step}
    ;;
  "down")
    [[ ${vol} -gt 0 ]] && pamixer --allow-boost -d ${step}
    ;;
  "mute")
    pamixer -t
    ;;
esac

vol=$(($(pamixer --get-volume)/${scale}))

if [[ $(pamixer --get-mute) == "true" ]]; then
  volnoti-show -m ${icons}
else
  volnoti-show ${icons} ${vol}
fi
