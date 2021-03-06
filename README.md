# Dotfiles

## Overview

This repo is my dotfiles.
It also contains an utility created by justone to help
with managing and updating your dotfiles like I manage mine.

## Using this repo

First, fork this repo.

Then, add your dotfiles:

    $ git clone --recursive git@github.com:tucksaun/.dotfiles.git
    $ cd .dotfiles
    $  # edit files
    $  # edit files
    $ git push origin master

Finally, to install your dotfiles onto a new system:

    $ cd $HOME
    $ git clone --recursive git@github.com:tucksaun/.dotfiles.git
    $ ./.dotfiles/bin/dfm  # creates symlinks to install files

    If your are on MacOS X, please install first Xcode and the Command Line Tools

## Full documentation

For more information, check out the [wiki](http://github.com/justone/dotfiles/wiki).

You can also run <tt>dfm --help</tt>.

