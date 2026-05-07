#!/bin/bash

###################################################################
# A script for reinstalling RMS. It backs up configuration files. #
# A script for reinstalling RMS. It backs up configuration files. #
# Works for both single- and multi-camera systems.                #
###################################################################


# Get ID from config
ID=$(awk -F': ' '/stationID:/ {print $2}' $HOME/source/RMS/.config)

# Folder for backups
BKP_FOLD=$HOME/"$ID"_backup_configs

# Create backup folder
mkdir --parents $BKP_FOLD

# Backup configs
cp --force --vebose $HOME/source/RMS/.config $BKP_FOLD/RMS
cp --force --vebose $HOME/source/RMS/platepar_cmn210.cal $BKP_FOLD/RMS
cp --force --vebose $HOME/source/RMS/mask.bmp $BKP_FOLD/RMS


# Download RMS
cd $HOME/source
cp --recurce --force RMS RMS.old
rm --recurce --force RMS
git clone https://github.com/CroatianMeteorNetwork/RMS.git
cd RMS


# Read the current computer's distribution
DIST="$(cat /etc/os-release | awk -F"=" '/^PRETTY_NAME/{print $2}')"

# Compare versions and get supported version
if [ "$DIST" = "Raspbian GNU/Linux 8 (jessie)" ]; then
	# For Raspberry Pi 3B+ Jessie
	git stash save --include-untracked
	git fetch origin
	git checkout legacy-python2
fi


# Install RMS
python setup.py install


# Restore configs
cp --force --vebose $BKP_FOLD/RMS/.config $HOME/source/RMS
cp --force --vebose $BKP_FOLD/RMS/platepar_cmn210.cal $HOME/source/RMS
cp --force --vebose $BKP_FOLD/RMS/mask.bmp $HOME/source/RMS

sudo reboot

