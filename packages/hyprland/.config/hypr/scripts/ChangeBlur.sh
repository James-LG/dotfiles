#!/bin/sh
# Toggle Hyprland window blur on/off.
state=$(hyprctl -j getoption decoration:blur:enabled | grep -oP '"int":\s*\K\d+')
if [ "$state" = "1" ]; then
    hyprctl keyword decoration:blur:enabled false
else
    hyprctl keyword decoration:blur:enabled true
fi
