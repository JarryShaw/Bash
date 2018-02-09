#!/bin/bash

echo -e "\n-*- Start VNC Server -*-\n"
tightvncserver

echo -e "\n-*- Restart Network Sharing -*-\n"
sudo /etc/init.d/avahi-daemon restart

echo -e "\n-*- Show Network State-*-\n"
sudo netstat -nlp | grep vnc

# sudo tcpdump -s 0 -i eth0 -w cmd_no_pi.pcap
