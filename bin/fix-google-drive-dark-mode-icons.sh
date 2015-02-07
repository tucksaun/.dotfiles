#!/bin/bash

function switch_files {
    mv $1.png $1.tmp.png
    mv $1-inverse.png $1.png
    mv $1.tmp.png $1-inverse.png
    mv $1@2x.png $1@2x.tmp.png
    mv $1-inverse@2x.png $1@2x.png
    mv $1@2x.tmp.png $1-inverse@2x.png
}  

RUNNING=`ps aux | grep '/Google Drive' | grep -v grep | wc -l | bc`
if [ "$RUNNING" = "1" ]; then
    killall 'Google Drive'
    while [ "$RUNNING" = "1" ]; do
        sleep 1
        RUNNING=`ps aux | grep '/Google Drive' | grep -v grep | wc -l | bc`
    done
fi
sleep 3

cd '/Applications/Google Drive.app/Contents/Resources/'
switch_files mac-animate1
switch_files mac-animate2
switch_files mac-animate3
switch_files mac-animate4
switch_files mac-animate5
switch_files mac-animate6
switch_files mac-animate7
switch_files mac-animate8
switch_files mac-error
switch_files mac-inactive
switch_files mac-normal
switch_files mac-paused
open '/Applications/Google Drive.app'
