#!/bin/sh
sudo ufw default allow outgoing 
sudo ufw default allow incoming
sudo ufw allow 80
ufw status verbose  
