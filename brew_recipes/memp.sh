#!/bin/bash

if [[ ! `which brew` ]]
then
    echo "Brew is not installed, please install it first"
    exit
fi

# Tap the wonderful homebrew-php from https://github.com/josegonzalez/homebrew-php
brew tap homebrew/dupes
brew tap josegonzalez/homebrew-php

echo "MEMP recipe is deprecated, skipping"
exit

PHP="php56"
PHP_VERSION="5.6"

# Install exim
brew install exim

# Install mysql
brew install mysql
if [ ! -d "/usr/local/var/mysql" ]
then
    unset TMPDIR
    sudo mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
fi

# Install php with apache, intl (for Symfony 2), and suhosin patch
PHP_OPTIONS="--without-snmp --with-gmp --with-mysql --with-pgsql --with-homebrew-openssl --with-intl --with-fpm --with-suhosin"
PHP_OPTIONS="--without-snmp --with-gmp --with-mysql --with-pgsql --with-homebrew-openssl --with-intl --with-fpm"
brew install $PHP $PHP_OPTIONS

PHP_PREFIX=$(brew --prefix josegonzalez/php/$PHP)
OLD_PEAR_DIR=$(pear config-get php_dir)
PEAR_DIR=/usr/local/lib/php/$PHP_VERSION/lib
PHP_EXT_DIR=/usr/local/lib/php/$PHP_VERSION/lib/extensions

rm -Rf $(php-config --extension-dir)
if [ ! -d $PEAR_DIR ]
then
    mkdir -p $PEAR_DIR
    cp -Rp $OLD_PEAR_DIR/* $PEAR_DIR/
    mkdir -p $PHP_EXT_DIR
fi
ln -nsf $PHP_EXT_DIR $(php-config --extension-dir)

if [ ! -f /usr/local/etc/php/$PHP_VERSION/conf.d/customisations.ini ]
then
    echo "; Original - display_errors = Off
display_errors = on
; Original - display_startup_errors = Off
display_startup_errors = on
date.timezone = Europe/Paris
detect_unicode = off
memory_limit=256M
suhosin.executor.include.whitelist = phar
xdebug.file_link_format=\"edit://%f#%l\"
extension_dir = $PHP_EXT_DIR
include_path=\".:$PEAR_DIR\"
" > /usr/local/etc/php/$PHP_VERSION/conf.d/customisations.ini
fi

# 'Fix' the default PEAR permissions and config
chmod -R ug+w $PEAR_DIR
pear config-set auto_discover 1
pear config-set php_ini /usr/local/etc/php/$PHP_VERSION/php.ini
pear config-set ext_dir $PHP_EXT_DIR
pear config-set php_dir $PEAR_DIR
pear config-set doc_dir $PEAR_DIR/doc
pear config-set cfg_dir $PEAR_DIR/cfg
pear config-set data_dir $PEAR_DIR/data

#install Net_Growl for Sismo\Contrib\GrowlNotifier
pear install Net_Growl
#Instal phpunit
pear install pear.phpunit.de/PHPUnit

#Install additional php extensions (Optional. Follow configuration instructions after each install.)
#brew install $PHP-intl
#brew install $PHP-apc
brew install $PHP-uploadprogress
brew install $PHP-xdebug
brew install $PHP-xhprof
brew install $PHP-imagick
brew install $PHP-twig
brew install graphviz

#Install composer for Symfony and other PHP package management
curl -s https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin

brew install phpmyadmin
if [ ! -f /usr/local/share/phpmyadmin/config.inc.php ]
then
    echo "<?php
/*
 * This is needed for cookie based authentication to encrypt password in
 * cookie
 */
\$cfg['blowfish_secret'] = '$(date | md5 -q)';
\$cfg['UploadDir'] = '';
\$cfg['SaveDir'] = '';
\$cfg['DefaultLang'] = 'fr';

/*
 * Servers configuration
 */
\$i = 0;

/*
 * First server
 */
\$i++;
/* Authentication type */
\$cfg['Servers'][\$i]['auth_type'] = 'config';
/* Server parameters */
\$cfg['Servers'][\$i]['host'] = 'localhost';
\$cfg['Servers'][\$i]['connect_type'] = 'tcp';
\$cfg['Servers'][\$i]['compress'] = false;
/* Select mysql if your server does not have mysqli */
\$cfg['Servers'][\$i]['extension'] = 'mysqli';
\$cfg['Servers'][\$i]['AllowNoPassword'] = true;
\$cfg['Servers'][\$i]['user'] = 'root';
\$cfg['Servers'][\$i]['password'] = '';

" > /usr/local/share/phpmyadmin/config.inc.php
fi

# nginx
brew install nginx
[ ! -d ~/Work ] && mkdir ~/Work
if [ ! -f ~/Work/nginx.conf ]
then
    echo 'worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include             mime.types;
    default_type        application/octet-stream;
    sendfile            on;
    keepalive_timeout   65;

    server {
        listen      80;
        server_name localhost;
        root        /Users/'`whoami`'/.localhost/web;
        index       index.php index.html;
        try_files   $uri $uri/ index;
        autoindex   on;

        location /phpmyadmin {
            alias /usr/local/share/phpmyadmin/;
            try_files $uri $uri/ /index.php;
        }

        location ~ ^/phpmyadmin/(.+\.php)$ {
            alias /usr/local/share/phpmyadmin/$1;
            fastcgi_index index.php;
            fastcgi_pass 127.0.0.1:9000;

            include fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_param PATH_INFO $fastcgi_path_info;
            fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT   /usr/local/share/phpmyadmin;
        }

        location ~ \.php {
            fastcgi_index   index.php;
            fastcgi_pass    127.0.0.1:9000;

            include                 fastcgi_params;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_param           PATH_INFO $fastcgi_path_info;
            fastcgi_param           PATH_TRANSLATED $document_root$fastcgi_path_info;
            fastcgi_param           SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }

    server {
        listen 80;

        server_name ~^(.+\.)+.*$ ;

        #domain like domain.dev
        if ($host ~ "^(.+).dev$") {
            set $root /Users/'`whoami`'/Work/$1;
        }
        #domain like foo.domain.dev
        if ($host ~ "^(.+)\.(.+).dev$") {
            set $root /Users/'`whoami`'/Work/$2/$1;
        }
        #domain like foo-dev.tucksaun.net
        if ($host ~ "^(.+)-dev\.tucksaun\.net$") {
            set $root /Users/'`whoami`'/Work/tucknet/$1;
        }

        if (-d $root/web) {
            set $root $root/web;
        }

        root        $root;
        index       app.php index.php index.html;
        try_files   $uri $uri/ @rewrite;

        location @rewrite {
            if (-f $root/app.php) {
                rewrite ^/(.*)$ /app.php/$1;
            }
            if (-f $root/index.php) {
                rewrite ^/(.*)$ /index.php/$1;
            }
        }

        location ~ \.php {
            fastcgi_index   index.php;
            fastcgi_pass    127.0.0.1:9000;

            include                 fastcgi_params;
            fastcgi_param           SERVER_NAME $host;
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_param           PATH_INFO $fastcgi_path_info;
            fastcgi_param           PATH_TRANSLATED $document_root$fastcgi_path_info;
            fastcgi_param           SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }
}
' > ~/Work/nginx.conf
    sudo ln -nsf ~/Work/nginx.conf /usr/local/etc/nginx/
fi

cd ~/.localhost && composer.phar install

# start Nginx
sudo nginx

# Remove outdated versions from the cellar
brew cleanup
