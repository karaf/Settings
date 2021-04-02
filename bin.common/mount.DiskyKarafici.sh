#!/bin/bash

#ip=$(sudo nmap -p 5000 192.168.15.* |\
ip=$(sudo nmap -p 5000 192.168.1.* |\
 awk '
/Nmap scan report for/{ip=$NF}
/Synology/{print ip; exit}' )

if [ -z $ip ]; then
  echo "No Synology driver detected on  192.168.1.\*"
else
    echo "mount  $ip:/volume1/DATA /mnt/DiskyKarafici"
     sudo mount  $ip:/volume1/DATA /mnt/DiskyKarafici
fi
