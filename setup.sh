#!/bin/bash

cd /var/www/html

mkdir -p /var/www/html/
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

echo "PHP has been installed and configured on Apache2."

service mariadb restart

mariadb -u root <<EOF
CREATE USER 'DBuser'@localhost IDENTIFIED BY 'password';
CREATE DATABASE wordpress;
GRANT ALL PRIVILEGES ON *.* TO 'DBuser'@localhost IDENTIFIED
BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'DBuser'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EOF

MYSQL_USER="DBuser"
MYSQL_PASSWORD="password"
DB_TABLE="wordpress"
db_name="born2beroot"
db_name="wordpress"

echo "Setting up permissions for var/www/html"
chown -R www-data:www-data /var/www/html 


sudo cp /etc/sudoers /etc/sudoers.bak

echo "wbousfir ALL=(ALL) NOPASSWD: /sbin/lvscan" | sudo tee -a /etc/sudoers

sudo cat /etc/sudoers | grep wbousfir

sudo apt install samba smbclient cifs-utils


echo -e "\033[35m \n\n\n\nStarting the verification ...\033[0m"


# Check if the MariaDB database  exists
database_exist=$(mariadb -u root -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$db_name'" | grep -o "$db_name")
if [ "$database_exist" = "$db_name" ]; then
  echo -e "\033[32mThe MariaDB database '$db_name' exists.\033[0m"
else
  echo -e "\033[31mThe MariaDB database '$db_name' does not exist.\033[0m"
fi

# Check if the user "DBuser" exists and has access to the database "nftstoredatabase"
user_exist=$(mariadb -u root -e "SELECT User FROM mysql.user" | grep -o "$MYSQL_USER" | head -n1)
if [ "$user_exist" = "$MYSQL_USER" ]; then
  echo -e "\033[32mThe user '$MYSQL_USER' exists.\033[0m"
  database_access=$(mariadb -u root -e "SHOW GRANTS FOR '$MYSQL_USER'@'%'" | grep "$db_name")
  if [ -n "$database_access" ]; then
    echo -e "\033[32mThe user '$MYSQL_USER' has access to the MariaDB database '$db_name'.\033[0m"
  else
    echo -e "\033[31mThe user '$MYSQL_USER' does not have access to the MariaDB database '$db_name'.\033[0m"
  fi
else
  echo -e "\033[31mThe user '$MYSQL_USER' does not exist.\033[0m"
fi


echo -e "\033[35m\n\n The verification is done ... \n\n \033[0m"

