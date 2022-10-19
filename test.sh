#!/bin/bash
var="$(lvscan | awk '{print $1}' | sed '2,6d')"
if [ $var = "ACTIVE" ]
then
	echo "LVM is in use"
else
	echo "LVM is not active"
fi
