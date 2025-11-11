#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */ ##
# Scripts for volume controls for audio and mic - CONVERTED TO WPCTL

iDIR="$HOME/.config/swaync/icons"
sDIR="$HOME/.config/hypr/scripts"

# Define the default sink and source for cleaner code
DEFAULT_SINK="@DEFAULT_AUDIO_SINK@"
DEFAULT_SOURCE="@DEFAULT_AUDIO_SOURCE@"

# Get Volume (Sink)
get_volume() {
    # Get volume and mute status for the default sink
    status=$(wpctl get-volume $DEFAULT_SINK)
    volume_float=$(echo "$status" | awk '{print $2}')
    is_muted=$(echo "$status" | grep -q 'MUTED' && echo 'true' || echo 'false')

    if [[ "$is_muted" == "true" ]]; then
        echo "Muted"
    else
        # Convert float (e.g., 0.65) to percentage (e.g., 65)
        volume_percent=$(echo "$volume_float * 100" | bc | awk '{print int($1)}')
        echo "$volume_percent %"
    fi
}

# Get icons (Unchanged, relies on get_volume)
get_icon() {
    current=$(get_volume)
    if [[ "$current" == "Muted" ]]; then
        echo "$iDIR/volume-mute.png"
    elif [[ "${current%\%}" -le 30 ]]; then
        echo "$iDIR/volume-low.png"
    elif [[ "${current%\%}" -le 60 ]]; then
        echo "$iDIR/volume-mid.png"
    else
        echo "$iDIR/volume-high.png"
    fi
}

# Notify (Unchanged, relies on get_volume and get_icon)
notify_user() {
    if [[ "$(get_volume)" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" " Volume:" " Muted"
    else
        notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$(get_icon)" " Volume Level:" " $(get_volume)" &&
        "$sDIR/Sounds.sh" --volume
    fi
}

# Increase Volume (Sink)
inc_volume() {
    # wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    wpctl set-volume $DEFAULT_SINK 5%+ && notify_user
    # Note: wpctl handles Mute state during volume change differently than pamixer.
    # It might be necessary to manually check for mute and unmute if desired.
}

# Decrease Volume (Sink)
dec_volume() {
    # wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    wpctl set-volume $DEFAULT_SINK 5%- && notify_user
}

# Toggle Mute (Sink)
toggle_mute() {
    # wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    wpctl set-mute $DEFAULT_SINK toggle

    # Re-check status for notification logic
    status=$(wpctl get-volume $DEFAULT_SINK)
    is_muted=$(echo "$status" | grep -q 'MUTED' && echo 'true' || echo 'false')

    if [[ "$is_muted" == "true" ]]; then
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/volume-mute.png" " Mute"
    else
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$(get_icon)" " Volume:" " Switched ON"
    fi
}

# Toggle Mic (Source)
toggle_mic() {
    # wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    wpctl set-mute $DEFAULT_SOURCE toggle

    # Re-check status for notification logic
    status=$(wpctl get-volume $DEFAULT_SOURCE)
    is_muted=$(echo "$status" | grep -q 'MUTED' && echo 'true' || echo 'false')

    if [[ "$is_muted" == "true" ]]; then
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/microphone-mute.png" " Microphone:" " Switched OFF"
    else
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/microphone.png" " Microphone:" " Switched ON"
    fi
}

# Get Microphone Volume (Source)
get_mic_volume() {
    # Get volume and mute status for the default source
    status=$(wpctl get-volume $DEFAULT_SOURCE)
    volume_float=$(echo "$status" | awk '{print $2}')
    is_muted=$(echo "$status" | grep -q 'MUTED' && echo 'true' || echo 'false')

    if [[ "$is_muted" == "true" ]]; then
        echo "Muted"
    else
        # Convert float (e.g., 0.65) to percentage (e.g., 65)
        volume_percent=$(echo "$volume_float * 100" | bc | awk '{print int($1)}')
        echo "$volume_percent %"
    fi
}

# Get Mic Icon (Unchanged logic, relies on get_mic_volume)
get_mic_icon() {
    current=$(get_mic_volume)
    if [[ "$current" == "Muted" ]]; then
        echo "$iDIR/microphone-mute.png"
    else
        echo "$iDIR/microphone.png"
    fi
}

# Notify for Microphone (Unchanged logic, relies on get_mic_volume and get_mic_icon)
notify_mic_user() {
    volume=$(get_mic_volume)
    icon=$(get_mic_icon)
    # The notify-send 'int:value' expects a number, so we strip the '%' or handle 'Muted'
    if [[ "$volume" == "Muted" ]]; then
        notify-send -e -u low -h boolean:SWAYNC_BYPASS_DND:true -i "$iDIR/microphone-mute.png" " Mic Level:" " Muted"
    else
        notify-send -e -h int:value:"$(echo "$volume" | sed 's/%//')" -h "string:x-canonical-private-synchronous:volume_notif" -h boolean:SWAYNC_BYPASS_DND:true -u low -i "$icon" " Mic Level:" " $volume"
    fi
}

# Increase MIC Volume (Source)
inc_mic_volume() {
    # wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+
    wpctl set-volume $DEFAULT_SOURCE 5%+ && notify_mic_user
}

# Decrease MIC Volume (Source)
dec_mic_volume() {
    # wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-
    wpctl set-volume $DEFAULT_SOURCE 5%- && notify_mic_user
}

# Execute accordingly (Unchanged)
if [[ "$1" == "--get" ]]; then
    get_volume
elif [[ "$1" == "--inc" ]]; then
    inc_volume
elif [[ "$1" == "--dec" ]]; then
    dec_volume
elif [[ "$1" == "--toggle" ]]; then
    toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
    toggle_mic
elif [[ "$1" == "--get-icon" ]]; then
    get_icon
elif [[ "$1" == "--get-mic-icon" ]]; then
    get_mic_icon
elif [[ "$1" == "--mic-inc" ]]; then
    inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
    dec_mic_volume
else
    get_volume
fi
