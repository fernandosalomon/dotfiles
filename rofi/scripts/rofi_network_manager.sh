#!/bin/bash

WIFI_DEVICE=$(nmcli -t -f DEVICE,TYPE device | grep ':wifi' | cut -d: -f1)
ROFI_CONFIG_FILE="$HOME/.config/rofi/configs/network_manager.rasi"
ROFI_CONFIG_FILE_PASSWORD="$HOME/.config/rofi/configs/network_password_menu.rasi"

wifi_status(){
	status=$(nmcli radio wifi)
	if [[ $status = "enabled" ]]; then
		return 0;
	else
		return 1;
	fi
}

wifi_is_connected(){
	is_connected=$(nmcli -t -f DEVICE,TYPE,STATE device | grep ':wifi:connected' >/dev/null && echo 1 || echo 0)
	if [ $is_connected = "1" ]; then
		return 0;
	else
		return 1;
	fi
}

toggle_power(){
	if wifi_power_on; then
		nmcli radio wifi off;
	else
		nmcli radio wifi on;
	fi
}

wifi_connect(){
	local SSID="$1"
	
	if [[ -z $SSID ]]; then
		echo "Error: No SSID";
		exit 1;
	fi
	
	SSID_security=$(nmcli -f SSID,SECURITY dev wifi | awk -v ssid="$SSID" '$0 ~ ssid {print $2}')
	if [ $SSID_security = "--" ]; then
		nmcli dev wifi connect $SSID;
	else
		local password=$(rofi -dmenu -p "Enter Password for $SSID:  " -config $ROFI_CONFIG_FILE_PASSWORD);
		nmcli dev wifi connect $SSID password $password;
	fi
}

wifi_disconnect(){
	nmcli device disconnect $WIFI_DEVICE
}

wifi_disconnect_forget(){
	SSID_current_network=$2
	
	nmcli device disconnect $WIFI_DEVICE
	
	if [[ -z $SSID_current_network ]]; then
		echo "Error: No SSID to forget";
	else
		nmcli connection delete id $SSID_current_network;
	fi
}

wifi_scan(){
	SSIDs=$(nmcli -t -f SSID dev wifi | grep -v '^$' | sort -u | paste -sd "," -)
	echo $SSIDs
}

wifi_connected_menu(){
	SSID_current_network="$2"
	options="Disconnect,Disconnect and Forget,Back,Exit"
	
	choice=$(echo $options | rofi -dmenu -sep "," -config $ROFI_CONFIG_FILE)
	
	if [[ $choice == "Disconnect" ]]; then
		wifi_disconnect;
	elif [[ $choice == "Disconnect and Forget" ]]; then
		wifi_disconnect_forget $SSID_current_network;
	elif [[ $choice == "Back" ]]; then
		wifi_menu;
	elif [[ $choice == "Exit" ]]; then
		exit 0;
	else
		echo "No choice selected.";
		exit 1;
	fi
}

wifi_menu(){
	echo $(wifi_status)
	if wifi_status; then
		if wifi_is_connected; then
			LOCAL_IP="$(nmcli -t -f IP4.ADDRESS device show | grep -m 1 -oP '\d+\.\d+\.\d+\.\d+')"
			SSID_current_network=$(iwconfig 2>/dev/null | grep 'ESSID' | awk -F 'ESSID:' '{print $2}' | tr -d '" ')
			options="Connected: $SSID_current_network (IP: $LOCAL_IP),Exit";
		else
			power="Power: On";
			SSIDs=$(wifi_scan);
			options="$power,$SSIDs,Exit";
		fi
	else
		power="Power: Off";
		options="$power,Exit";
	fi
	
	choice=$(echo $options | rofi -dmenu -sep "," -config $ROFI_CONFIG_FILE)
	
	if [[ $choice = "Exit" ]]; then
		exit 0;
	elif [[ $choice = "Power:Off" ]]; then
		toggle_power;
	elif [[ $choice = "Power:On" ]]; then
		toggle_power;
	elif [[ -z $choice ]]; then
		echo "No selected choice";
		exit 1;
	elif [[ $choice == Connected:* ]]; then
		wifi_connected_menu $SSID_current_network;
	else
		wifi_connect $choice
	fi
}

wifi_menu
