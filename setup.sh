#!/usr/bin/env bash
set -e

export PATH="/opt/homebrew/bin:$PATH"
export DOTFILE_DIR="${HOME}/.dotfiles"

if ! command -v mas &> /dev/null; then
    brew install mas
fi

if [ ! -f /Library/Apple/usr/libexec/oah/libRosettaRuntime ]; then
    sudo softwareupdate --install-rosetta --agree-to-license
fi

for set in sets/*; do
    # shellcheck source=/dev/null
    source "$set"
done
