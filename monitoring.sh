#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: cmariot <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/07/31 13:30:41 by cmariot           #+#    #+#              #
#    Updated: 2021/07/31 13:30:41 by cmariot          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

###VARIABLES FOR :###
#architecture
	architecture=$(uname -a)
#physical_cpu
	physical_cpu=$(getconf _NPROCESSORS_ONLN)
#virtual_cpu
	virtual_cpu=$(cat /proc/cpuinfo | grep processor | wc -l)
#memory usage
	total_memory=$(free -m | grep 'Mem' | awk '{print $2}')
	use_memory=$(free -m | grep 'Mem' | awk '{print $3}')
	memory_quotient=$(echo "$use_memory/$total_memory")
	percent_memory=$(echo "$((use_memory * 100 / total_memory))")
	memory=$(echo $memory_quotient'MB ('$percent_memory'%)')
#disk usage
	total_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{ts += $2}END{print ts}')
	use_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{us += $3}END{print us}')
	percent_space=$(df -Bm | grep '^/dev' | grep -v '/boot$' | awk '{ts += $2}{us += $3}END{printf("%d"), us/ts*100}')
	disk=$(echo ""$use_space"/"$total_space"MB ("$percent_space"%)")
#cpu load
	cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 11- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
#last_reboot
	last_boot=$(who -b | awk '{print $3 " " $4}')
#Script for the lvm_use variable
	lsblk=$(lsblk | grep 'lvm' | wc -l)
	if [ $lsblk -eq 0 ]
	then
		lvm_use=$(echo 'no')
	else
		lvm_use=$(echo 'yes')
	fi
#tcp
	tcp_connections=$(ss | grep 'tcp' | grep 'ESTAB' | wc -l && echo -n "ESTABLISHED")
#user log
	user=$(w | head -1 | awk '{print $4}')
#network
	ip_addr=$(hostname -I)
	mac_addr=$(ip link show | grep 'ether' | awk '{print "(" $2 ")"}')
	network=$(echo "IP " && echo $ip_addr && echo $mac_addr)
#sudo
	sudolog_lines=$(wc -l /var/log/sudo/sudo.log | awk '{print $1}')
	sudo=$(echo "$((sudolog_lines / 2))")


###PRINT VARIOABLES###
#ok
echo -n "#Architecture " ; 	echo $architecture ;
#ok
echo -n "#CPU physical: " ; 	echo $physical_cpu ;
#ok
echo -n "#vCPU: " ;		echo $virtual_cpu ;
#ok
echo -n "#Memory Usage: " ;	echo $memory ;
#Disk usage ou filesystem ? 30Go ou 10 Go ?
echo -n "#Disk Usage: " ;	echo $disk ;
#
echo -n "#CPU load: " ;		echo $cpu_load ;
#ok
echo -n "#Last boot: " ;	echo $last_boot ;
#ok
echo -n "#LVM use: " ;		echo $lvm_use ;
#ok
echo -n "#TCP Connections: " ;	echo $tcp_connections ;
#bug
echo -n "#User log: " ;		echo $user ;
#ok
echo -n "#Network: " ;		echo $network
#ok
echo -n "#Sudo: " ;		echo $sudo ;
