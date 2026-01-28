#!/bin/bash
# Get current default source (mic) mute state
MUTED=$(pactl get-source-mute @DEFAULT_SOURCE@ | grep yes)

# Toggle mute
pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Play different sound based on PRE-toggle state (invert for post-toggle)
if [ -z "$MUTED" ]; then
    paplay --volume=30000 ~/.local/scripts/pedal/discordmute.mp3
		echo "muted"
else
    paplay --volume=30000 ~/.local/scripts/pedal/discord-unmute.mp3
		echo "unmuted"
fi
