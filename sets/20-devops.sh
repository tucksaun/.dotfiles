#!/usr/bin/env bash
set -e

brew install \
    s3cmd scw awscli terraform \
    shellcheck

if [ ! -d "/Applications/Blackmagic Disk Speed Test.app" ]; then
    mas install 425264550
fi

if [ ! -d /Applications/Cyberduck.app ]; then
    brew install --cask cyberduck
fi

if [ ! -d /Applications/TeamViewer.app ]; then
    brew install --cask teamviewer
fi

if [ ! -d /Applications/balenaEtcher.app ]; then
    brew install --cask balenaetcher
fi

if [ ! -d "/Applications/DB Browser for SQLite.app" ]; then
    brew install --cask db-browser-for-sqlite
fi

if [ ! -f ~/.screenrc ]; then
    ln -nsf "${DOTFILE_DIR}/screenrc" "${HOME}/.screenrc"
fi
