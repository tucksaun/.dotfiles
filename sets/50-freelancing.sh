#!/usr/bin/env bash
set -e

if [ ! -d "/Applications/Toggl Track.app" ]; then
    mas install 1291898086
fi

if [ ! -d "/Applications/Fantastical.app" ]; then
    brew install --cask fantastical
fi

if [ ! -d /Applications/Trello.app ]; then
    mas install 1278508951
fi

if [ ! -d "/Applications/Microsoft Word.app" ]; then
    brew install --cask microsoft-word microsoft-excel microsoft-powerpoint
fi
