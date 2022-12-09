#!/bin/sh
sudo ufw default deny outgoing 
sudo ufw default deny incoming
ufw deny 80
ufw status verbose  
