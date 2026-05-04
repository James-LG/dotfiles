#!/bin/sh
# Power menu via wofi. Names match the action performed on selection.

choice=$(printf '%s\n' \
    "Lock" \
    "Logout" \
    "Suspend" \
    "Reboot" \
    "Shutdown" \
    | wofi --dmenu --insensitive --prompt "Power" --width 300 --height 280 --cache-file /dev/null)

case "$choice" in
    Lock)     hyprlock ;;
    Logout)   hyprctl dispatch exit ;;
    Suspend)  systemctl suspend ;;
    Reboot)   systemctl reboot ;;
    Shutdown) systemctl poweroff ;;
esac
