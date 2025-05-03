#!/bin/bash

WALL_DIR="$HOME/.config/hypr/wallpapers"

# swww transition config
FPS=30
TYPE="any"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION --transition-bezier $BEZIER"

get_images(){
for a in $WALL_DIR/*.jpg $WALL_DIR/*.png $WALL_DIR/*jpeg $WALL_DIR/*webp $WALL_DIR/*bpm $WALL_DIR/*tiff; do
	wallpaper_name=$(basename "$a") 
	printf "%s\x00icon\x1f%s\n" "$wallpaper_name" "$a" 
done
}

main(){
selected=$(get_images | rofi -i -show -dmenu -theme ~/.config/rofi/configs/wallpaperSelector.rasi)
choice=$(echo $selected | xargs)

if [[ -z "$choice" ]]; then
    echo "No choice selected. Exiting."
    exit 0
  fi

# Kill existing wallpaper daemons for image
kill_wallpaper_for_image() {
  pkill mpvpaper 2>/dev/null
  pkill swaybg 2>/dev/null
  pkill hyprpaper 2>/dev/null
}

 if ! pgrep -x "swww-daemon" >/dev/null; then
    echo "Starting swww-daemon..."
    swww-daemon --format xrgb &
  fi

$(swww img "$WALL_DIR/$choice" $SWWW_PARAMS)
}

# Check if rofi is already running
if pidof rofi >/dev/null; then
  pkill rofi
fi

main



