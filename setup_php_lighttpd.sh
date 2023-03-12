#!/bin/bash

# Install PHP7.4 and Lighttpd web server
apt update
apt install -y lighttpd php7.4-cgi php7.4-common php7.4-mysql
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
echo "<?php phpinfo(); ?>" > /var/www/info.php

lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php

service lighttpd force-reload

systemctl restart lighttpd.service
