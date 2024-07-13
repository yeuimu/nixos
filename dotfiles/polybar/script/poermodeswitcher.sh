#!/bin/bash

current_mode=$(powerprofilesctl get)

# 切换电源模式
if [ "$1" == "--toggle" ]; then
  case $current_mode in
    "performance")
      powerprofilesctl set balanced
      ;;
    "balanced")
      powerprofilesctl set power-saver
      ;;
    "power-saver")
      powerprofilesctl set performance
      ;;
  esac
fi

# 查看状态
if [ "$1" == "--status" ]; then
  case $current_mode in
    "performance")
      icon="󰛕"
      ;;
    "balanced")
      icon="󰖨"
      ;;
    "power-saver")
      icon="󰒲"
      ;;
  esac
#  echo "$icon $current_mode"
  echo "  $icon "
fi

