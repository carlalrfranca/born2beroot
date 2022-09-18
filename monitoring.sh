Monitoring

#!/bin/bash
ARC=$(uname -a)
CPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
VCP=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)
FRAM=$(free --mega | grep Mem | awk '{print $2}')
URAM=$(free --mega | grep Mem | awk '{print $3}')
PRAM=$(free --mega | grep Mem | awk '{print $3/$2 * 100}' | xargs printf "%.2f")
FDISK=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}' | tr -d '\n')
UDISK=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}' | tr -d '\n')
PDISK=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}' | tr -d '\n')
CPUL=$(mpstat | grep all | awk '{printf "#CPU Load: %.2f\n", 100 - $NF}')
LSBT=$(who -b | awk '{printf "%s %s\n", $4, $5}')
LVMT=$(lsblk | grep "lvm" | wc -l)
LVMU=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
CT=$(cat /proc/net/sockstat | grep -i tcp | awk '{print $3}' | tr -d '\n')
UL=$(users | wc -w)
IP=$(hostname -I)
MAC=$(/sbin/ifconfig | grep "ether " | awk '{print $2}')
SD=$(grep sudo /var/log/auth.log | grep "COMMAND=" | wc -l | tr -d '\n)
wall "     #Architecture: $ARC
           #CPU physical: $CPU
           #vCPU: $VCP
           #Memory Usage: $URAM/${FRAM}MB ($PRAM%)
           #Disk Usage: $UDISK/${FDISK}Gb ($PDISK%)
           #CPU load: ${CPUL}%
           #Last boot: $LSBT
           #LVM use: $LVMU
           #Connexions TCP: $CT  ESTABLISHED
           #User log: $UL
           #Network: IP $IP ($mac)
           #Sudo: $SD cmd "
