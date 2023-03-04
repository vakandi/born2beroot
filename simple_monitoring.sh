#!/bin/bash
RED='\033[36m'
BLUE='\033[35m'
GREEN='\033[32m'
BACK_GREEN='\033[42m'
BACK_PURPLE='\033[45m'
PURPLE='\033[35m'
ORANGE='\033[33m'
END='\033[0m'  
RAM_AVAILABLE=$(free -m | awk '{print $7}' | sed '1d' | sed '2d')
RAM_TOTAL=$(free -m | awk '{print $2}' | sed '1d' | sed '2d')
RAM_LEFT=$(echo "($RAM_TOTAL-$RAM_AVAILABLE)"|bc)

TOTAL_DISK_GIGA=$(echo "$(df -BG | awk '{print $2}' | sed '1d' | rev | cut -c2-| rev)" > giga.tmp && awk '{s+=$1} END {print s}' giga.tmp)
FREE_DISK_GIGA=$( echo "$(df -BG | awk '{print $4}' | sed '1d' | rev | cut -c2-| rev  )" > giga.tmp && awk '{s+=$1} END {print s}' giga.tmp)
REAL_FREE_DISK_GIGA=$( echo "$TOTAL_DISK_GIGA - $FREE_DISK_GIGA" |bc)    
PERCENT_GIGA=$(echo "(100 - (100*$FREE_DISK_GIGA/$TOTAL_DISK_GIGA))" |bc)
LVM_CHECK="$(sudo lvscan | awk '{print $1}' | sed '1,6d')"
NUM_TCP=$(ss -s | grep TCP | sed '1d' | cut -c7)
TOR_CHECK=$(curl --socks5 localhost:9050 --socks5-hostname localhost:9050 -s https://check.torproject.org/ | cat | grep -m 1 Congratulations | xargs)
CPU_LOAD9="$(mpstat | awk '{print $3}' | sed '1,3d'| tr "," ".")"
CPU_LOAD1="$(mpstat | awk '{print $4}' | sed '1,3d'| tr "," ".")"
CPU_LOAD2="$(mpstat | awk '{print $5}' | sed '1,3d'| tr "," ".")"
CPU_LOAD3="$(mpstat | awk '{print $6}' | sed '1,3d'| tr "," ".")"
CPU_LOAD4="$(mpstat | awk '{print $7}' | sed '1,3d'| tr "," ".")"
CPU_LOAD5="$(mpstat | awk '{print $8}' | sed '1,3d'| tr "," ".")"
CPU_LOAD6="$(mpstat | awk '{print $9}' | sed '1,3d'| tr "," ".")"
CPU_LOAD7="$(mpstat | awk '{print $10}' | sed '1,3d'| tr "," ".")"
CPU_LOAD8="$(mpstat | awk '{print $11}' | sed '1,3d'| tr "," ".")"

RESULT_CPU_LOAD=$(echo "$CPU_LOAD1+$CPU_LOAD2+$CPU_LOAD3+$CPU_LOAD4+$CPU_LOAD5+$CPU_LOAD6+$CPU_LOAD7+$CPU_LOAD8+$CPU_LOAD9" | bc)

echo -e "${BLUE}Architecture:${END} ${GREEN}$(uname -a)${END}"

echo -e "${BLUE}CPU Physical: ${END}${GREEN}$(lscpu | grep Architecture | wc -l)${END}"

echo -e "${BLUE}vCPU:${END}${GREEN} $(grep processor /proc/cpuinfo | sed 's#processor##g' | cut -c3- | wc -l)${END}"

echo -e "${BLUE}Memory Usage: ${END}${GREEN}$(echo "($RAM_TOTAL-($RAM_TOTAL-$RAM_LEFT))"|bc) Mo/$RAM_TOTAL Mo $(echo "(100 *$RAM_LEFT/$RAM_TOTAL)"|bc)% ${END}"

echo -e "${BLUE}Disk Usage:${END}${GREEN} $REAL_FREE_DISK_GIGA Go/$TOTAL_DISK_GIGA Go ($PERCENT_GIGA%)${END}" 

echo -e "${BLUE}CPU Load : ${END}${GREEN}$RESULT_CPU_LOAD %${END}"



echo -e "${BLUE}Last Boot:${END}${GREEN} $(last reboot |less| head -n1 | cut -c40-56)${END}"


if [ $LVM_CHECK = "ACTIVE" ]
then
	echo -e "${BLUE}LVM use: ${END}${GREEN}yes${END} "
else
	echo -e "${BLUE}LVM use: ${END}${GREEN}no${END} "
fi
NUM_TCP=$(ss -s | grep TCP | sed '1d' | cut -c7)

echo -e "${BLUE}Connections TCP : ${END}${GREEN}$NUM_TCP${END} ${BLUE} ESTABLISHED${END} "

echo -e "${BLUE}User log: ${END}${GREEN}$(w | awk '{print $1}' |sed '1,2d' | sort -u | wc -l)${END} "

rm giga.tmp
	if [ -z $TOR_CHECK ]
	then
		echo -e "${BLUE}      Network:${END}            ${RED}SOCKS.5-TORPROXY: ${END}"
		echo -e "${RED}||||||||||||||||||||||  |||||||||||||||||||||||${END}"
		echo -e "${RED}|| ${END}${BACK_GREEN}[$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')]${END} ${RED}||   ||${END} ${BACK_PURPLE}[ NOT CONNECTED ]${END} ${RED}||${END}"
		echo -e "${RED}|||||||||||||||||||||| ${END}${RED} |||||||||||||||||||||||${END}" 
	else
		echo -e "${BLUE}Network:${END}"
		echo -e "${RED}||||||||||||||||||||| ${END} ${RED}SOCKS.5-TORPROXY: ${END}"
		echo -e "${RED}||${END}${BACK_GREEN} [$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')]${END} ||"
		echo -e "${RED}||||||||||||||||||||| ${END} ${BACK_GREEN}[ $TOR_CHECK ]${END}" 
	fi
	
	MAC_ADDRESS="$(sudo ifconfig | grep ether |cut -c15- | awk '{print $1}')"
	echo -e "${BLUE}MAC Address of the current internet connection(s):${END}\n${GREEN}$MAC_ADDRESS${END}"
	
	
	echo -e "${BLUE}Sudo : ${END}${GREEN}$(sudo cat /var/log/sudo/sudo.log | grep COMMAND | awk '{print NR}' | awk 'END { print }') cmd${END}"


