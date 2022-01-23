#!/usr/bin/env bash
set -e

if [ ! -f "/opt/homebrew/bin/brew" ]; then
    echo " ** Homebrew is not installed **"
    echo "Installing it as first thing because it will provide for Git"
    echo "and allow us to install more apps."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo " ** Cloning dotfiles repo **"
git clone "https://github.com/tucksaun/.dotfiles" "${HOME}/.dotfiles"

(cd "${HOME}/.dotfiles" && ./setup.sh)
