#!/usr/bin/env bash
set -e

if ! grep "pam_tid.so" "/etc/pam.d/sudo" > /dev/null ; then
    echo 'Enabling TouchID for sudo';
    sudo sed -i '' '2i\
auth       sufficient     pam_tid.so\
' /etc/pam.d/sudo
fi

# If the directory is not present it means the OS will not support LaunchAgents
# and we should not try to copy the plist file or load it
if [ -d  ~/Library/LaunchAgents ]; then
    cp "${DOTFILE_DIR}/me.tucksaun.ssh-agent.plist" ~/Library/LaunchAgents/me.tucksaun.ssh-agent.plist
    launchctl load -w ~/Library/LaunchAgents/me.tucksaun.ssh-agent.plist
    launchctl stop "user/$UID/com.openssh.ssh-agent"
    launchctl disable "user/$UID/com.openssh.ssh-agent"
    launchctl enable "user/$UID/me.tucksaun.ssh-agent"
    launchctl start "user/$UID/me.tucksaun.ssh-agent"
fi