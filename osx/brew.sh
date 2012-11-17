#!/bin/bash

if [[ ! `which brew` ]]
then
    echo "Brew is not installed, installing it first"
    ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
echo "Don’t forget to add $(brew --prefix coreutils)/libexec/gnubin to \$PATH."
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install Bash 4
brew install bash
brew install bash-completion

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install everything else
brew install ack
brew install aria2
brew install git
brew install gnu-sed
brew install grep

for file in $(ls $BASE_DIR/brew_recipes/*.sh)
do
    echo "> execute $file"
    source $file
done
exit;

# Remove outdated versions from the cellar
brew cleanup
