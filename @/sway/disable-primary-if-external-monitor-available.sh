#!/bin/bash

X=$(swaymsg -t get_outputs | jq '.[0].model')

# disable the main monitor if the external one is found
if [[ $X == '"LEN L24e-20"' ]]; then
  swaymsg output eDP-1 disable
fi

echo "hi" >> /home/khang/.config/sway/yes
