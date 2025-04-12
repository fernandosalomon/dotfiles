#!/bin/bash

EWW=`which eww`

if [[ "$1" == "--firefox" ]]; then
	$EWW close-all && firefox &

elif [[ "$1" == "--spotify" ]]; then
	$EWW close-all && spotify &

elif [[ "$1" == "--terminal" ]]; then
	$EWW close-all && kitty ~ &

elif [[ "$1" == "--files" ]]; then
	$EWW close-all && thunar ~ &

elif [[ "$1" == "--code" ]]; then
	$EWW close-all && code ~ &

elif [[ "$1" == "--screenshot" ]]; then
	$EWW close-all &&  grim -g "$(slurp)" &

elif [[ "$1" == "--firefox-priv" ]]; then
	$EWW close-all && firefox --private-window &

elif [[ "$1" == "--search" ]]; then
	$EWW close-all && firefox --new-window https://chatgpt.com/ &

else
    echo "Wrong option"

fi
