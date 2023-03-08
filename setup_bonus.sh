#!/bin/bash

sudo apt install samba smbclient cifs-utils


echo "Add this line to this file /etc/samba/smb.conf\nworkgroup = WORKGROUP"

echo "workgroup = WORKGROUP" >> /etc/samba/smb.conf

sudo mkdir /public
sudo mkdir /private

echo "[public]" >> /etc/samba/smb.conf
echo "   comment = Public Folder" >> /etc/samba/smb.conf
echo "   path = /public" >> /etc/samba/smb.conf
echo "   writable = yes" >> /etc/samba/smb.conf
echo "   guest ok = yes" >> /etc/samba/smb.conf
echo "   guest only = yes" >> /etc/samba/smb.conf
echo "   force create mode = 775" >> /etc/samba/smb.conf
echo "   force directory mode = 775" >> /etc/samba/smb.conf
echo "[private]" >> /etc/samba/smb.conf
echo "   comment = Private Folder" >> /etc/samba/smb.conf
echo "   path = /private" >> /etc/samba/smb.conf
echo "   writable = yes" >> /etc/samba/smb.conf
echo "  guest ok = no" >> /etc/samba/smb.conf
echo "  valid users = @smbshare" >> /etc/samba/smb.conf   
echo "  force create mode = 770" >> /etc/samba/smb.conf   
echo "  force directory mode = 770" >> /etc/samba/smb.conf
echo "  inherit permissions = yes" >> /etc/samba/smb.conf



sudo groupadd smbshare

sudo chgrp -R smbshare /private/

sudo chgrp -R smbshare /public


sudo chmod 2770 /private/

sudo chmod 2775 /public

sudo useradd -M -s /sbin/nologin sambauser

sudo usermod -aG smbshare sambauser

sudo smbpasswd -a sambauser

sudo smbpasswd -e sambauser

sudo testparm

sudo mkdir /private/demo-private /public/demo-public

sudo touch /private/demo1.txt /public/demo2.txt

sudo systemctl restart nmbd

#sudo ufw allow from 192.168.205.0/24 to any app Samba

