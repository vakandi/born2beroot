#!/bin/sh
sudo ufw default deny outgoing 
sudo ufw default deny incoming
ufw deny 80
ufw enable
ufw status verbose  
