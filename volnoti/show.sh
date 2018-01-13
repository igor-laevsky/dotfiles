#!/bin/bash

icons="
 -0 /home/igor/.config/volnoti/icons/mute.svg
 -1 /home/igor/.config/volnoti/icons/off.svg
 -2 /home/igor/.config/volnoti/icons/down.svg
 -3 /home/igor/.config/volnoti/icons/down.svg
 -4 /home/igor/.config/volnoti/icons/up.svg"

if amixer get Master | grep -Fq "[off]"; then
  volnoti-show -m ${icons}
else
  volnoti-show $(amixer get Master | grep -Po "[0-9]+(?=%)" | tail -1) ${icons}
fi
