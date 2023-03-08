#!/bin/bash

# Install PHP7.4 and Lighttpd web server
apt update
apt install -y lighttpd php7.4-cgi php7.4-common php7.4-mysql

# Configure PHP on Lighttpd
echo 'fastcgi.server += ( ".php" => \
   ( "php-cgi" => \
     ( "socket" => "/var/run/php/php7.4-cgi.sock", \
       "bin-path" => "/usr/bin/php-cgi", \
       "max-procs" => 1, \
       "bin-environment" => ( \
         "PHP_FCGI_CHILDREN" => "4", \
         "PHP_FCGI_MAX_REQUESTS" => "10000" \
       ), \
       "broken-scriptfilename" => "enable" \
     ) \
   ) \
)' >> /etc/lighttpd/conf-enabled/15-fastcgi-php.conf

# Restart Lighttpd to apply changes
systemctl restart lighttpd.service
#!/bin/bash

echo "<?php phpinfo(); ?>" > /var/www/html/info.php
echo "<?php phpinfo(); ?>" > /var/www/info.php

echo "PHP has been installed and configured on lighttpd."
