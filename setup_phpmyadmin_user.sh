#!/bin/bash

mariadb -u root <<EOF
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@localhost IDENTIFIED
BY 'password';
FLUSH PRIVILEGES;
EOF


