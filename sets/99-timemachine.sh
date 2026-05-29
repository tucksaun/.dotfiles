#!/usr/bin/env bash
set -e

echo " ** Setuping TimeMachine **"
for exclusion in $HOME/Pictures/Raw "$HOME/Pictures/Lightroom Catalog" $HOME/Music $HOME/Movies $HOME/Library/Caches $HOME/Library/CloudStorage $HOME/Library/Containers/com.docker.docker $HOME/Library/pnpm "$HOME/Library/Application Support/JetBrains" "$HOME/Library/Application Support/Spotify" "$HOME/Library/Application Support/Steam" "$HOME/Library/Application Support/Syncthing" $HOME/.composer $HOME/.asdf /Applications; do
    sudo tmutil addexclusion -p "$exclusion"
done

if ! sudo tmutil destinationinfo | grep -i phoenyx; then
    sudo tmutil setdestination -ap "smb://tucksaun@phoenyx.lan/TimeMachine"
fi

sudo tmutil enable
