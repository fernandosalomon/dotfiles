#!/bin/bash

MUSIC_DIR="$HOME/Music"

get_status() {
	STATUS=$(playerctl status)
	if [[ $STATUS = "Playing" ]]; then
		echo ""
	else
		echo "喇"
	fi
}

get_song() {
	song=`playerctl metadata "title"`
	if [[ -z "$song" ]]; then
		echo "Offline"
	else
		echo "$song"
	fi	
}

get_artist() {
	artist=`playerctl metadata "artist"`
	if [[ -z "$artist" ]]; then
		echo "Offline"
	else
		echo "$artist"
	fi	
}

get_time() {
	STATUS=$(playerctl status)
	if [[ $STATUS = "Playing" ]]; then
		pos=$(playerctl position)
		len=$(playerctl metadata mpris:length)
		echo "$pos $len" | awk '{ printf "%d\n", ($1 * 1000000 / $2) * 100 }'
	else
		echo 0.0
	fi
}

get_cover() {
	DEFAULT_COVER="$HOME/.config/eww/assets/img/player/default-cover.png"
	
	url=$(playerctl --player=spotify metadata mpris:artUrl)

	if [[ "$url" == http* ]]; then
    	echo "$url"
	else
    	echo "$DEFAULT_COVER" 
	fi
}

is_muted(){
	is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')

	if [ "$is_muted" = "sí" ]; then
	    echo true
	else
    	echo false
	fi
}

if [[ "$1" == "--song" ]]; then
	get_song
elif [[ "$1" == "--artist" ]]; then
	get_artist
elif [[ "$1" == "--status" ]]; then
	get_status
elif [[ "$1" == "--time" ]]; then
	get_time
elif [[ "$1" == "--cover" ]]; then
	get_cover
elif [[ "$1" == "--toggle" ]]; then
	playerctl play-pause
elif [[ "$1" == "--next" ]]; then
	{ playerctl next; get_cover; }
elif [[ "$1" == "--prev" ]]; then
	{ playerctl prev; get_cover; }
elif [[ "$1" == "--is-muted" ]]; then
	is_muted
fi