#!/bin/sh
# Toggle wofi: close if already running, otherwise launch the app menu.
pgrep -x wofi >/dev/null && pkill -x wofi || exec wofi --show drun --insensitive
