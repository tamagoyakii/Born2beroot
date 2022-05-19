#!/bin/bash

#1
printf "#Architecture: $(uname -a)\n"
#2
printf "#CPU physical: $(nproc --all)\n"
#3
printf "#vCPU: $(cat /proc/cpuinfo | grep processor | wc -l)\n"
#4
tmem=$(free -m | grep Mem | awk '{print $2}')
umem=$(free -m | grep Mem | awk '{print $3}')
pmem=$(free -m | grep Mem | awk '{printf "%.2f", $3/$2*100}' | xargs)
printf "#Memory Usage: ${umem}/${tmem}MB (${pmem}%%)\n"
#5
tdisk=$(df -m | grep LVMGroup | awk '{sum+=$2}END{printf "%.2f", sum/1000}'
udisk=$(df -m | grep LVMGroup | awk '{sum+=$3}END{printf "%.2f", sum/1000}'
pdisk=$(df -m | grep LVMGroup | awk '{tdisk+=$2}{udisk+=$3}END{printf "%.2f", udisk/tdisk*100}')
printf "#Disk Usage: ${udisk}/${tdisk}GB (${pdisk}%%)\n"
#6
printf "#CPU Load: $(top -bn1 | grep Cpu | awk '{print $2+$4}')%%\n)"
#7
printf "#Last boot: $(who -b | awk '{print $3 " " $4}')\n"
#8
lvmt=$(lsblk | grep lvm | wc -l)
printf "#LVM use: $(if [${lvmt} -eq 0 ]; them echo "no"; else echo "yes"; fi)\n"
#9
printf "#Connections TCP: $(ss | grep tcp | wc -l) ESTABLISHED\n"
#10
printf "#User log: $(who | wc -l)\n"
#11
printf "#Network: IP $(hostname -I)($(ip link show | grep ether | awk '{print $2}'))\n)"
#12
printf "#Sudo: $(journalctl | grep sudo | grep COMMAND | wc -l) cmd\n"
