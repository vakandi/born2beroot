#!/bin/bash
RED=''
BLUE=''
GREEN=''
BACK_GREEN=''
BACK_ORANGE=''
PURPLE=''
ORANGE=''
END=''
RAM_AVAILABLE=$(free -m | awk '{print $7}' | sed '1d' | sed '2d')
RAM_TOTAL=$(free -m | awk '{print $2}' | sed '1d' | sed '2d')
RAM_LEFT=$(echo "($RAM_TOTAL-$RAM_AVAILABLE)"|bc)

TOTAL_DISK_GIGA=$(echo "$(df -BG | awk '{print $2}' | sed '1d' | rev | cut -c2-| rev)" > giga.tmp && awk '{s+=$1} END {print s}' giga.tmp)
FREE_DISK_GIGA=$( echo "$(df -BG | awk '{print $4}' | sed '1d' | rev | cut -c2-| rev  )" > giga.tmp && awk '{s+=$1} END {print s}' giga.tmp)
PERCENT_GIGA=$(echo "(100 - (100*$FREE_DISK_GIGA/$TOTAL_DISK_GIGA))" |bc)
LVM_CHECK="$(lvscan | awk '{print $1}' | sed '2,6d')"
NUM_TCP=$(ss -s | grep TCP | sed '1d' | cut -c7)
TOR_CHECK=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs)



echo "${BLUE}Architecture:${END} ${GREEN}$(uname -a)${END}"

echo "${BLUE}CPU Physical: ${END}${GREEN}$(lscpu | grep 'Processeur' | cut -c42-)${END}"

echo "${BLUE}vCPU:${END}${GREEN}$(grep processor /proc/cpuinfo | sed 's#processor##g' | cut -c3-)${END}"

echo "${BLUE}Memory Usage: ${END}${GREEN}$(echo "($RAM_TOTAL-($RAM_TOTAL-$RAM_AVAILABLE))"|bc) Mo/$RAM_TOTAL Mo $(echo "(100 *$RAM_LEFT/$RAM_TOTAL)"|bc)% ${END}"

echo "${BLUE}Disk Usage:${END}${GREEN} $TOTAL_DISK_GIGA Go/$FREE_DISK_GIGA Go ($PERCENT_GIGA%)${END}" 

echo "${BLUE}${END}${GREEN}$(cat /proc/stat | grep cpu| tail -1|awk '{print ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}' | awk '{print "CPU Load: " 100-$1"%"}')${END}"

echo "${BLUE}Last Boot:${END}${GREEN} $(last reboot |less| head -n1 | cut -c40-56)${END}"

if [ $LVM_CHECK = "ACTIVE" ]
then
	echo "${BLUE}LVM use: ${END}${GREEN}yes${END} "
else
	echo "${BLUE}LVM use: ${END}${GREEN}no${END} "
fi
NUM_TCP=$(ss -s | grep TCP | sed '1d' | cut -c7)

echo "${BLUE}Connections TCP : ${END}${GREEN}$NUM_TCP${END} "

echo "${BLUE}User log: ${END}${GREEN}$(w | awk '{print $1}' |sed '1,2d' | sort -u | wc -l)${END} "


if [ -z $TOR_CHECK ]
then
	echo "${BLUE}Network:${END}"
	echo "${RED}|||||||||||||||||||||| ${END} ${RED}SOCKS.5-TORPROXY: ${END}"
	echo "${RED}||${END}${BACK_GREEN} [$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')]${END} ||"
	echo "${RED}|||||||||||||||||||||| ${END} ${BACK_ORANGE}[ NOT CONNECTED]${END}" 
else
	echo "${BLUE}Network:${END}"
	echo "${RED}|||||||||||||||||||||| ${END} ${RED}SOCKS.5-TORPROXY: ${END}"
	echo "${RED}||${END}${BACK_GREEN} [$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')]${END} ||"
	echo "${RED}|||||||||||||||||||||| ${END} ${BACK_GREEN}[ $TOR_CHECK ]${END}" 
fi


echo "${BLUE}MAC Address of the current internet connection(s):${END}  ${GREEN}$(ifconfig | grep ether |cut -c15- | awk '{print $1}')${END}"

echo "${BLUE}Sudo : ${END}${GREEN}$(cat /var/log/sudo/sudo.log | grep COMMAND | awk '{print NR}' | awk 'END { print }') cmd${END}"




