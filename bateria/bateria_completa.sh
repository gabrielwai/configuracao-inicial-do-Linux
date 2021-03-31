#!/bin/bash

sleep 104

echo 937 > /sys/class/backlight/intel_backlight/brightness
sleep 2
echo 237 > /sys/class/backlight/intel_backlight/brightness
sleep 2
echo 937 > /sys/class/backlight/intel_backlight/brightness

aplay /usr/share/sounds/sound-icons/glass-water-1.wav

sleep 1800
