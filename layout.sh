#!/bin/bash

export DISPLAY=":0"

case "$1" in
  single)
    xrandr --fb 1920x1080 --output HDMI-0 --off --output DP-2 --mode 3840x2160 --pos 0x0 --rotate normal --scale 0.5 --filter nearest
    xrandr --output DP-2 --panning 0x0+0+0
    nitrogen --restore
    #~/.config/polybar/launch.sh
    ;;

  dual-1200)
    ## xrandr method is very unstable
    # xrandr --output DP-2 --panning 0x0+0+0 
    # xrandr --output DP-2 --mode 3840x2160 --pos 0x120 --rotate normal --scale 0.5 --filter nearest
    # xrandr --fb 3840x1200
    # xrandr --output HDMI-0 --panning 0x0+0+0
    # xrandr  --fb 3840x1200 --output HDMI-0 --mode 1920x1200 --pos 1920x0 --rotate normal

    nvidia-settings --assign "CurrentMetaMode=DPY-3: nvidia-auto-select @1920x1080 +0+120
      {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Nearest}, DPY-2: nvidia-auto-select @1920x1200
        +1920+0 {ViewPortIn=1920x1200, ViewPortOut=1920x1200+0+0}"    
    
    nitrogen --restore
    #~/.config/polybar/launch.sh
    ;;

  dual-work)
    ## Scaling using xrandr post-processing
    # nvidia-settings --assign "CurrentMetaMode=DPY-3: nvidia-auto-select @1920x1080 +0+1080 
    #   {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Nearest}, DPY-2: nvidia-auto-select @1920x1080
    #     +1920+1080 {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Nearest}"

    ## Scaling by setting up lower resolution (works slighly better than above)
    nvidia-settings --assign "CurrentMetaMode=DPY-3: nvidia-auto-select @1920x1080 +0+1080 
      {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Nearest}, DPY-2: 1920x1080 @1920x1080
        +1920+1080 {ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0}"
    nitrogen --restore
    #~/.config/polybar/launch.sh
    ;;
  
  apple-keyboard)
    echo "1" | sudo tee /sys/module/hid\_apple/parameters/swap_opt_cmd
    echo "2" | sudo tee /sys/module/hid_apple/parameters/fnmode     # F-keys didn't work
    echo "0" | sudo tee /sys/module/hid_apple/parameters/iso_layout # Fix ~ key position
    ;;
esac
