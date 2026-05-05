#!/bin/sh
# Show active special workspaces in wofi; toggle the chosen one.
# If wofi is already open, close it instead of stacking instances.
pgrep -x wofi >/dev/null && exec pkill -x wofi

choice=$(hyprctl workspaces -j \
    | jq -r '.[] | select(.name | startswith("special:")) | .name | sub("^special:"; "")' \
    | wofi --dmenu --insensitive --prompt "Special" --cache-file /dev/null)

[ -n "$choice" ] && hyprctl dispatch togglespecialworkspace "$choice"
