#!/bin/bash

#1 The architecture of your operating system and its kernel version.
printf "#Architecture: $(uname -a)\n"

#2 The number of physical processors.
printf "#CPU physical: $(nproc --all)\n"

#3 The number of virtual processors.
printf "#vCPU: $(cat /proc/cpuinfo | grep processor | wc -l)\n"

#4 The current available RAM on your server and its utilization rate as a percentage.
tmem=$(free -m | grep Mem | awk '{print $2}')
umem=$(free -m | grep Mem | awk '{print $3}')
pmem=$(free -m | grep Mem | awk '{printf "%.2f", $3/$2*100}')
printf "#Memory Usage: ${umem}/${tmem}MB (${pmem}%%)\n"

#5 The current available memory on your server and its utilization rate as a percentage.
tdisk=$(df -m | grep LVMGroup | awk '{sum+=$2}END{printf "%.2f", sum/1000}'
udisk=$(df -m | grep LVMGroup | awk '{sum+=$3}END{printf "%.2f", sum/1000}'
pdisk=$(df -m | grep LVMGroup | awk '{tdisk+=$2}{udisk+=$3}END{printf "%.2f", udisk/tdisk*100}')
printf "#Disk Usage: ${udisk}/${tdisk}GB (${pdisk}%%)\n"

#6 The current utilization rate of your processors as a percentage.
printf "#CPU Load: $(top -bn1 | grep Cpu | awk '{print $2+$4}')%%\n)"

#7 The date and time of the last reboot.
printf "#Last boot: $(who -b | awk '{print $3 " " $4}')\n"

#8 Whether LVM is active or not.
lvmt=$(lsblk | grep lvm | wc -l)
printf "#LVM use: $(if [${lvmt} -eq 0 ]; them echo "no"; else echo "yes"; fi)\n"

#9 The number of active connections.
printf "#Connections TCP: $(ss | grep tcp | wc -l) ESTABLISHED\n"

#10 The number of users using the server.
printf "#User log: $(who | wc -l)\n"

#11 The IPv4 address of your server and its MAC (Media Access Control) address.
printf "#Network: IP $(hostname -I)($(ip link show | grep ether | awk '{print $2}'))\n)"

#12 The number of commands executed with the sudo program.
printf "#Sudo: $(journalctl | grep sudo | grep COMMAND | wc -l) cmd\n"
