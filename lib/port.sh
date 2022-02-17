#!/bin/bash -e
#Port Forwarding
echo -e "\n\e[1;44mPort Forwarding (80 > 1337).\e[0m"
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections &>> ${LOG}
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections &>> ${LOG}
sudo apt install -y iptables-persistent &>> ${LOG}
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1337
echo -e "\e[1;32mPort forwarding successfully configured.\e[0m"