#!/bin/bash

# The script redirects the standard output of the RMS_StartCapture module to a text file,
# which allows you to log all errors that are not reflected in the standard log file.
#
# Create a symbolic link on your desktop
#
#	cd ~/Desktop
#	ln -s ~/source/ExScripts/Utils/logger_StartCapture.sh
#
# To activate, add the script to autorun,
# or run it through the terminal to monitor the process for one night.
#
#
# Add to autorun
# ===============================================================
# | USE THE CORRECT USERNAME FOR YOUR OPERATING SYSTEM VERSION! |
# | pi - for RPi 3B+ Jessie and RPi4 for Buster.                |
# | rms - for RPi4 Bookworm.                                    |
# ===============================================================
#
# 1. Open the file.
#
# for RPi 3B+ Jessie:
#
#	sudo nano /home/pi/.config/lxsession/LXDE-pi/autostart
#
# or for RPi4 Buster or Bookworm:
#
#	sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
#
# 2. Comment out the line:
#
# @lxterminal -e "/home/pi/Desktop/RMS_FirstRun.sh
#			rms
#
# 3. Add this command after the commented line:
#
# @lxterminal -e /home/pi/Desktop/logger_StartCapture.sh
#		       rms


# Folder for writing logs
LOG_DIR="$HOME/RMS_data/logs/logger_StartCapture"


# Create a folder for writing logs if it does not exist
mkdir --parents $LOG_DIR

# Write the standard output of the module to the log
$HOME/Desktop/RMS_StartCapture.sh 2>&1 | tee $LOG_DIR/$(hostname)_RMS_StartCapture_$(date +%F_%T).log
