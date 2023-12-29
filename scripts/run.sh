#!/bin/sh

xrdb merge ~/.config/chadwm/.Xresources 
xbacklight -set 10 &
feh --bg-fill ~/.wallpaper/wallpaper.png &
xset r rate 200 50 &
picom &

dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
