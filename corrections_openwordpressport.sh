#!/bin/sh
echo "Type "open" to open the 1337 port with "ufw", type "close" for the opposit\nThen press ENTER"
read input
check="$(ufw status verbose | grep 1337 | awk '{print $2}' | head -n1)"
if [ $input = "open" ]; then
	if [ $check = "ALLOW" ]; then
		echo "1337 Port is already open, exiting..."
	else
		echo "Opening 1337 port..."
		ufw allow 1337
		echo "Done\nExiting.."
	fi
elif [ $input = "close" ]; then
	if [ $check = "DENY" ]; then
		echo "1337 Port is already close, exiting..."
	else
		echo "Closing 1337 port..."
		ufw deny 1337
		echo "Done\nExiting.."
	fi
else
	echo "Bad argument, type "open" or "close""
	exit
fi
	
