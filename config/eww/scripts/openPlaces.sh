#!/bin/bash

EWW=`which eww`

if [[ "$1" == "--Documents" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/Documentos &

elif [[ "$1" == "--Downloads" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/Descargas &

elif [[ "$1" == "--Pictures" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/Pictures &

elif [[ "$1" == "--config" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/.config &

elif [[ "$1" == "--ProgramFiles" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/ProgramFiles &

elif [[ "$1" == "--Imagenes" ]]; then
	${EWW} kill && ${EWW} close-all && thunar $HOME/Imágenes &

else
    echo "Wrong option"

fi
