#!/bin/bash

printf "\n-*- Start VNC Server -*-\n"
tightvncserver

printf "\n-*- Restart Network Sharing -*-\n"
sudo /etc/init.d/avahi-daemon restart

printf "\n-*- Show Network State-*-\n"
sudo netstat -nlp | grep vnc

cd Desktop/

# sudo tcpdump -s 0 -i eth0 -w cmd_no_pi.pcap
