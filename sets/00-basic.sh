#!/usr/bin/env bash
set -e

# AppStore only
# brew install --cask bitwarden
if [ ! -d /Applications/Bitwarden.app ]; then
    mas install 1352778147
fi

if [ ! -d /Applications/Syncthing.app ]; then
    brew install --cask syncthing
    echo ".DS_Store
    .AppleDB
    .AppleDesktop
    .apdisk
    Icon" > ~/.global_stignore
fi

if [ ! -d "/Applications/Google Chrome.app" ]; then
    brew install --cask google-chrome
fi

if [ ! -d /Applications/Spotify.app ]; then
    brew install --cask spotify
fi

if [ ! -d /Applications/Calibre.app ]; then
    brew install --cask calibre
fi

if [ ! -d /Applications/VLC.app ]; then
    brew install --cask vlc
fi

if [ ! -d /Applications/Messenger.app ]; then
    brew install --cask messenger
fi

if [ ! -d /Applications/Signal.app ]; then
    brew install --cask signal
fi

if [ ! -d /Applications/WhatsApp.app ]; then
    brew install --cask whatsapp
fi

if [ ! -d /Applications/Skype.app ]; then
    brew install --cask skype
fi

if [ ! -d /Applications/Steam.app ]; then
    brew install --cask steam
fi

if [ ! -d "/Applications/Google Drive.app" ]; then
    brew install --cask google-drive
fi
