#!/usr/bin/env bash
set -e

if [ ! -d "/Applications/Adobe Creative Cloud" ]; then
    brew install --cask adobe-creative-cloud
    # Adobe Lightroom Classic
    # Adobe Photoshop 2022
fi

if [ ! -d "/Applications/ExifRenamer.app" ]; then
    brew install --cask exifrenamer
fi

if [ ! -d "/Applications/ImageOptim.app" ]; then
    brew install --cask imageoptim
fi

if [ ! -d "/Applications/TinyPNG4Mac.app" ]; then
    brew install --cask tinypng4mac
fi

# SiriL.app
