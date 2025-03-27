#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

WORKSPACE="$1"
NUM_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE" | wc -l)

ALL_MONITORS=$(aerospace list-monitors | choose 0)
for MONITOR in $ALL_MONITORS; do
    ON_MONITOR=$(aerospace list-workspaces --monitor "$MONITOR" | grep -c "$WORKSPACE")
    if [ "$ON_MONITOR" -eq 0 ]; then
        sketchybar --set $NAME display=$MONITOR
        break
    fi
done

if [ "$NUM_WINDOWS" -eq 0 ]; then
    sketchybar --set $NAME drawing=off
    exit 0
else
    sketchybar --set $NAME drawing=on
fi

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on
else
    sketchybar --set $NAME background.drawing=off
fi
