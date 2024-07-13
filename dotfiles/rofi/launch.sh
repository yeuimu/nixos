#!/bin/bash

drun() {
  xrandr_output=$(bspc query -M --names)
  if echo "$xrandr_output" | grep -q "HDMI-A-0" || "$xrandr_output" | grep -q "center"; then
    rofi \
      -theme-str "* {font: \"serif 15\";}" \
      -theme-str "element-icon {size: 40px;}" \
      -theme-str "window {width: 500px;}" \
      -show drun
  else
    rofi \
      -show drun
  fi
}

music() {
  xrandr_output=$(bspc query -M --names)
  ifmonitor=if echo "$xrandr_output" | grep -q "HDMI-A-0" || "$xrandr_output" | grep -q "center"
  ~/.config/rofi/mpd/mpd $ifmonitor
}

case $1 in
  "drun")
    drun
    ;;
  "music")
    music
    ;;
esac

