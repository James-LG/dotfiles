#!/bin/bash

# Find the current CPU Scaling Governor for CPU0 (usually 'powersave' or 'performance')
# This is a good indicator of the TLP profile in effect.
GOVERNOR=$(cat /sys/firmware/acpi/platform_profile)

# You can adjust the output format to your liking (e.g., with icons)
if [ "$GOVERNOR" = "powersave" ]; then
    TEXT=" TLP: PowerSave" # Replace  with your preferred icon
    CLASS="tlp-powersave"
elif [ "$GOVERNOR" = "performance" ]; then
    TEXT=" TLP: Performance" # Replace  with your preferred icon
    CLASS="tlp-performance"
else
    # Fallback for other governors like 'schedutil' or 'ondemand'
    TEXT=" TLP: $GOVERNOR"
    CLASS="tlp-other"
fi

# Output the result as JSON for better Waybar integration
# The 'class' allows for custom CSS styling based on the profile.
echo "{\"text\": \"$TEXT\", \"class\": \"$CLASS\"}"
