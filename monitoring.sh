#!/bin/bash

echo
echo -n "Architecture: "
echo
echo -n "CPU Physical: "
echo
echo -n "vCPU: "
echo
echo -n "Memory usage: "
echo
echo -n "Disk Usage: "
echo
echo -n "CPU load: "
echo
echo -n "Last boot: "
last reboot | head -n 1 | cut -f 2 -d '~' |  cut -c26-
echo -n "LVM use: "
echo
echo -n "Connexions TCP: "
netstat -an | grep "ESTABLISHED" | wc -l | tr -d '[:space:]'
echo " ESTABLISHED"
echo -n "User log: "
who | wc -l | tr -d '[:space:]'
echo
echo -n "Network: IP "
ipconfig getifaddr en0 | tr -d '[:space:]'
echo -n " ("
ifconfig en0 ether | grep 'ether' | cut -f 2 -d ' ' | tr -d '[:space:]'
echo ")"
echo -n "Sudo: "
wc -l "sudo.log" | cut -f 1 -d 's' | tr -d '[:space:]'
echo " cmd"
