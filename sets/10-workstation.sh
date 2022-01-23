#!/usr/bin/env bash
set -e

# Nice tools for a nice workstation setup
if [ ! -d /Applications/BetterSnapTool.app ]; then
    mas install 417375580
fi

if [ ! -d /Applications/eqMac.app ]; then
    brew install --cask eqmac
fi

if [ ! -d /Applications/Lunar.app ]; then
    brew install --cask lunar
fi

# This one is anoying to install for now because it requires a full Xcode setup 😲
# Let's hope we will soon have a binary release 🤩
if [ ! -f /opt/homebrew/bin/autokbisw ]; then
    (brew install ohueter/tap/autokbisw && brew services start ohueter/tap/autokbisw) || true
fi

# Let's have a productive terminal!
if [ ! -d /Applications/iTerm.app ]; then
    brew install --cask iterm2
    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Preferences"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
fi

# Oh My ZSH
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    mkdir -p "${HOME}/.oh-my-zsh/custom/plugins/icloud-credentials"
    ln -ns "${DOTFILE_DIR}/icloud-credentials.zsh-plugin" "${HOME}/.oh-my-zsh/custom/plugins/icloud-credentials/icloud-credentials.plugin.zsh"
    ln -ns "${DOTFILE_DIR}/tucksaun.zsh-theme" "${HOME}/.oh-my-zsh/custom/themes/tucksaun.zsh-theme"
    ln -ns "${DOTFILE_DIR}/zshrc" "${HOME}/.zshrc"
fi

if [ ! -f "${HOME}/.ssh/config" ]; then
    mkdir -p "${HOME}/.ssh"
    ln -ns "${DOTFILE_DIR}/ssh-config" "${HOME}/.ssh/config"
    ln -ns "${HOME}/Library/Mobile Documents/com~apple~CloudDocs/Preferences/id_rsa" "${HOME}/.ssh/id_rsa"
fi
