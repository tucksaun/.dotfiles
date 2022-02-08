#!/usr/bin/env bash
set -e

echo " ** Setuping TimeMachine **"
for exclusion in $HOME/Pictures/Raw "$HOME/Pictures/Lightroom Catalog" $HOME/Music $HOME/Movies $HOME/Library/Caches "$HOME/Library/Application Support/JetBrains" $HOME/.composer /Applications/Xcode.app "/Applications/Microsoft Word.app" "/Applications/Microsoft Excel.app" "/Applications/Microsoft PowerPoint.app" "/Applications/Adobe Creative Cloud" "/Applications/Adobe Photoshop 2022" "/Applications/Adobe Lightroom Classic"; do
    sudo tmutil addexclusion -p "$exclusion"
done

if ! sudo tmutil destinationinfo | grep -i Phoenyx; then
    sudo tmutil setdestination -ap "smb://tucksaun@Phoenyx._smb._tcp.local./TimeMachine"
fi

sudo tmutil enable
