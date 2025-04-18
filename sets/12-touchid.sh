#!/usr/bin/env bash
set -e

if ! grep "pam_tid.so" "/etc/pam.d/sudo" > /dev/null ; then
    echo 'Enabling TouchID for sudo';
    sudo sed -i '' '2i\
auth       sufficient     pam_tid.so\
' /etc/pam.d/sudo
fi

if ! which touch2sudo > /dev/null; then
    brew tap prbinu/touch2sudo
    brew install touch2sudo
fi

mkdir -p ~/Library/LaunchAgents
cp "${DOTFILE_DIR}/me.tucksaun.ssh-agent.plist" ~/Library/LaunchAgents/me.tucksaun.ssh-agent.plist
launchctl load -w ~/Library/LaunchAgents/me.tucksaun.ssh-agent.plist
launchctl stop "user/$UID/com.openssh.ssh-agent"
launchctl disable "user/$UID/com.openssh.ssh-agent"
launchctl enable "user/$UID/me.tucksaun.ssh-agent"
launchctl start "user/$UID/me.tucksaun.ssh-agent"