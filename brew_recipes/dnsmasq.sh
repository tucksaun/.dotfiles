#!/bin/bash

if [[ ! `which brew` ]]
then
    echo "Brew is not installed, please install it first"
    exit
fi

# Make sure we’re using the latest Homebrew
brew update

# Install dnsmasq for local wildcard domain.
brew install dnsmasq
if [ ! -f "/usr/local/etc/dnsmasq.conf" ]
then
    echo "listen-address=127.0.0.1
listen-address=192.168.59.3
resolv-file=/etc/resolv.conf
address=/.dev/127.0.0.1" > /usr/local/etc/dnsmasq.conf

    sudo mkdir /etc/resolver
    sudo chmod 777 /etc/resolver
    # be carefull, .local is not available if Bonjour is activated !
    echo "nameserver 127.0.0.1" > /etc/resolver/dev
    echo "nameserver 172.17.42.1" > /etc/resolver/docker
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

# Remove outdated versions from the cellar
brew cleanup
