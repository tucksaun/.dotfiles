#!/bin/bash

if [[ ! `which brew` ]]
then
    echo "Brew is not installed, please install it first"
    exit
fi

PHP="php54"
PHP_VERSION="5.4"

# Make sure we’re using the latest Homebrew
brew update

# Install dnsmasq for local wildcard domain.
brew install dnsmasq
if [ ! -f "/usr/local/etc/dnsmasq.conf" ]
then
    echo "address=/.local/127.0.0.1
address=/.dev/127.0.0.1" > /usr/local/etc/dnsmasq.conf

    sudo mkdir /etc/resolver
    sudo chmod 777 /etc/resolver
    # be carefull, .local is not available if Bonjour is activated !
    echo "nameserver 127.0.0.1" > /etc/resolver/local
    echo "nameserver 127.0.0.1" > /etc/resolver/dev
    # used for offline mode, see https://github.com/37signals/pow/issues/104#issuecomment-7057102
    echo "nameserver 127.0.0.1
domain ." > /etc/resolver/root
    sudo chmod 755 /etc/resolver
fi
if [ ! -f "/Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist" ]
then
    sudo cp /usr/local/Cellar/dnsmasq/*/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
    sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
    sudo launchctl stop homebrew.mxcl.dnsmasq
    sudo launchctl start homebrew.mxcl.dnsmasq
fi

# Install exim
brew install exim

# Install mysql
brew install mysql
if [ ! -d "/usr/local/var/mysql" ]
then
    unset TMPDIR
    sudo mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
fi

# Tap the wonderful homebrew-php from https://github.com/josegonzalez/homebrew-php
brew tap homebrew/dupes
brew tap josegonzalez/homebrew-php

# Install php with apache, intl (for Symfony 2), and suhosin patch
PHP_OPTIONS="--with-gmp --with-mysql --with-pgsql --with-homebrew-openssl --with-intl --with-debug --with-suhosin"
PHP_OPTIONS="--with-gmp --with-mysql --with-pgsql --with-homebrew-openssl --with-intl --with-debug"
brew install $PHP $PHP_OPTIONS

PHP_PREFIX=$(brew --prefix josegonzalez/php/$PHP)
OLD_PEAR_DIR=$(pear config-get php_dir)
PEAR_DIR=/usr/local/lib/php/$PHP_VERSION/lib
PHP_EXT_DIR=/usr/local/lib/php/$PHP_VERSION/lib/extensions

rm -Rf $(php-config --extension-dir)
if [ ! -d $PEAR_DIR ]
then
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

#Install additional php extensions (Optional. Follow configuration instructions after each install.)
brew install $PHP-apc
brew install $PHP-uploadprogress
brew install $PHP-xdebug
brew install $PHP-xhprof
brew install $PHP-twig
brew install graphviz

#Install composer for Symfony and other PHP package management
curl -s https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin

#Instal phpunit
wget http://pear.phpunit.de/get/phpunit.phar -O ~/bin/phpunit.phar && chmod 755 ~/bin/phpunit.phar

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

# Configure native apache
[ ! -d ~/Work ] && mkdir ~/Work
if [ ! -f ~/Work/httpd-vhosts.conf ]
then
    echo "
User $(whoami)
Group staff
NameVirtualHost *
# get the server name from the Host: header
UseCanonicalName Off
LoadModule php5_module $PHP_PREFIX/libexec/apache2/libphp5.so
SetEnv HOME /Users/$(whoami)

# For http://localhost in the OS X default location
<VirtualHost *>
    ServerName localhost
    DocumentRoot /Users/$(whoami)/Work/
    <Directory \"/Users/$(whoami)/Work\">
        Options FollowSymLinks Indexes
        AllowOverride All
        Order deny,allow
    </Directory>

    Alias /phpmyadmin /usr/local/share/phpmyadmin
    <Directory /usr/local/share/phpmyadmin/>
        Options -Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>

<VirtualHost *>
    ServerAlias *.tucknet.dev
    ServerAlias *.tucksaun.net
    # get the server name from the Host: header
    # include the server name (minus the tld) in the filenames used to satisfy requests
    VirtualDocumentRoot /Users/$(whoami)/Work/tucknet/%-3+
    <Directory \"/Users/$(whoami)/Work/tucknet/*/\">
        Options FollowSymLinks Indexes
        AllowOverride All
        Order deny,allow
        DirectoryIndex app.php index.php index.html index.htm

        RewriteEngine On
        #RewriteBase /

        #Symfony applications
        RewriteCond web/app.php -F [OR]
        RewriteCond web/index.php -F
        RewriteCond %{REQUEST_URI}  ^(.*)$
        RewriteRule ^(.*)$ /web%1 [NS]
    </Directory>

    <Directory \"/Users/$(whoami)/Work/tucknet/*/web/\">
        Options FollowSymLinks Indexes
        AllowOverride None
        Order deny,allow
        DirectoryIndex app.php index.php

        RewriteEngine On
        RewriteBase /web

        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond app.php -F
        RewriteRule ^(.*)$ app.php [QSA,L,NS]
        RewriteCond index.php -F
        RewriteRule ^(.*)$ index.php [QSA,L,NS]
    </Directory>
</VirtualHost>

<VirtualHost *>
    ServerAlias *.dev
    # get the server name from the Host: header
    # include the server name (minus the tld) in the filenames used to satisfy requests
    VirtualDocumentRoot /Users/$(whoami)/Work/%-2+
    <Directory \"/Users/$(whoami)/Work/*/\">
        Options FollowSymLinks Indexes
        AllowOverride All
        Order deny,allow
        DirectoryIndex app.php index.php index.html index.htm

        RewriteEngine On
        #RewriteBase /

        #Symfony applications
        RewriteCond web/app.php -F [OR]
        RewriteCond web/index.php -F
        RewriteCond %{REQUEST_URI}  ^(.*)$
        RewriteRule ^(.*)$ /web%1 [NS]
    </Directory>

    <Directory \"/Users/$(whoami)/Work/*/web/\">
        Options FollowSymLinks Indexes
        AllowOverride None
        Order deny,allow
        DirectoryIndex app.php index.php

        RewriteEngine On
        RewriteBase /web

        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond app.php -F
        RewriteRule ^(.*)$ app.php [QSA,L,NS]
        RewriteCond index.php -F
        RewriteRule ^(.*)$ index.php [QSA,L,NS]
    </Directory>
</VirtualHost>
" > ~/Work/httpd-vhosts.conf
    sudo ln -nsf ~/Work/httpd-vhosts.conf /etc/apache2/other/
fi

# Restart Apache
sudo apachectl -k restart

# Remove outdated versions from the cellar
brew cleanup
