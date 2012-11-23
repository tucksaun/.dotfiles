#!/usr/bin/env sh

read -p "Would you like to launch ENV setup? " -n 1
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 0
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "> setup dotfiles"

BASE_DIR=$(dirname $0);

if [ $(uname) = "Darwin" ]
then
	SETUP_DIR="$BASE_DIR/osx"
elif [ $(uname) = "Linux" ]
then
	SETUP_DIR="$BASE_DIR/linux"
fi

for file in $(ls $SETUP_DIR/*.sh)
do
	echo "> execute $file"
	source $file
done

echo "settings updated. Note that some of these changes require a logout/restart to take effect."
