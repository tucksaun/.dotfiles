#!/usr/bin/env sh

if [ $(scutil --get LocalHostName) = "MacBook-Pro-de-Tugdual" ]
then
	# Set computer name (as done via System Preferences → Sharing)
	sudo scutil --set ComputerName "tucksaun-mbp"
	sudo scutil --set HostName "tucksaun-mbp"
	sudo scutil --set LocalHostName "tucksaun-mbp"
	# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "MathBook-Pro"
fi
