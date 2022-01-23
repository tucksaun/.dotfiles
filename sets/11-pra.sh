#!/usr/bin/env bash
set -e

if [ ! -d "${HOME}/.pra" ]; then
    git clone git@github.com:tucksaun/pra.git "${HOME}/.pra"
fi

if ! grep -qi "EF4E47E3-A3A8-39EE-A57E-C2108262F6DF" /etc/fstab; then
    echo "UUID=EF4E47E3-A3A8-39EE-A57E-C2108262F6DF none msdos ro,noauto" | sudo tee -a /etc/fstab
fi
