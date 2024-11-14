# Output
# xrandr --output DP-1-4-2 --primary --mode 1920x1080
# xrandr --output DP-1-4-1 --mode 1920x1080 --right-of DP-1-4-2
# xrandr --output DP-1-4-3 --mode 1920x1080 --left-of DP-1-4-2
xrandr --output HDMI-0 --primary --mode 1920x1080 -r 100.000
xrandr --output DP-4 --mode 1920x1080 --rotate left --left-of HDMI-0 -r 75.00
feh --bg-fill /home/lucian/.config/wallpapers/background.png --bg-fill /home/lucian/.config/wallpapers/background.png
# Turn Off Screen going to sleep
xset s off
xset -dpms
xset s noblank
