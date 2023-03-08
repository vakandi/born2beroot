#!/bin/bash

sudo apt install samba smbclient cifs-utils


echo "Add this line to this file /etc/samba/smb.conf\nworkgroup = WORKGROUP"

echo "workgroup = WORKGROUP" >> /etc/samba/smb.conf

sudo mkdir /public
sudo mkdir /private

echo "[public]
   comment = Public Folder
   path = /public
   writable = yes
   guest ok = yes
   guest only = yes
   force create mode = 775
   force directory mode = 775
[private]
   comment = Private Folder
   path = /private
   writable = yes
   guest ok = no
   valid users = @smbshare
   force create mode = 770
   force directory mode = 770
   inherit permissions = yes
" >> /etc/samba/smb.conf



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

