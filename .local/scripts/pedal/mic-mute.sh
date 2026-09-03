#!/bin/sh

# The mic state watcher owns mute/unmute cues for every toggle source.
exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
