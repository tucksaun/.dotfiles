#!/usr/bin/env bash
set -e

brew install \
    coreutils findutils the_silver_searcher gnu-sed \
    git git-delta \
    dos2unix \
    colordiff diffutils \
    curl watch wget \
    postgresql \
    node yarn \
    python \
    php \
    symfony-cli/tap/symfony-cli

if [ ! -d "/Applications/GPG Keychain.app" ]; then
    brew install --cask gpg-suite
fi

if [ ! -d /Applications/Firefox.app ]; then
    brew install --cask firefox
fi

if [ ! -d /Applications/Postman.app ]; then
    brew install --cask postman
fi

if [ ! -d /Applications/Slack.app ]; then
    brew install --cask slack
fi

if [ ! -d "/Applications/Visual Studio Code.app" ]; then
    brew install --cask visual-studio-code
fi

if [ ! -d "/Applications/IntelliJ IDEA.app" ]; then
    brew install --cask intellij-idea
fi

# Git settings
if [ ! -f ~/.gitconfig ]; then
    ln -nsf "${DOTFILE_DIR}/gitconfig" "${HOME}/.gitconfig"
fi
