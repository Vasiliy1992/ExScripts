#!/bin/bash

###################################################################
# A script for reinstalling RMS. It backs up configuration files. #
###################################################################


# Get ID from config
ID=$(awk -F': ' '/stationID:/ {print $2}' $HOME/source/RMS/.config)

# Folder for backups
BKP_FOLD=$HOME/"$ID"_backup_configs


# Create backup folder
mkdir --parents $BKP_FOLD


# Backup configs
cp --preserve --verbose --update $HOME/source/RMS/.config $BKP_FOLD/RMS
cp --preserve --verbose --update $HOME/source/RMS/platepar_cmn2010.cal $BKP_FOLD/RMS
cp --preserve --verbose --update $HOME/source/RMS/mask.bmp $BKP_FOLD/RMS


cd $HOME/source


# Remove old RMS backup
rm --recursive --force RMS.old


echo -e "\nBackup RMS folder:\n=================\n"
mv --no-target-directory --verbose RMS RMS.old


echo -e "\nDownload RMS:\n============\n"
git clone https://github.com/CroatianMeteorNetwork/RMS.git
cd RMS


# Import PRETTY_NAME from /etc/os-release
source /etc/os-release

# Compare versions and get supported version
if [ "$PRETTY_NAME" = "Raspbian GNU/Linux 8 (jessie)" ]; then
	# For Raspberry Pi 3B+ Jessie
	echo -e "\nGit checkout to legacy-python2 branch (for RPi3B+)\n"
	git stash save --include-untracked
	git fetch origin
	git checkout legacy-python2
fi


echo -e "\nInstall RMS:\n===========\n"
python setup.py install


echo -e "\nRestore configs:\n===============\n"
cp --force --preserve --verbose $BKP_FOLD/RMS/.config $HOME/source/RMS
cp --force --preserve --verbose $BKP_FOLD/RMS/platepar_cmn2010.cal $HOME/source/RMS
cp --force --preserve --verbose $BKP_FOLD/RMS/mask.bmp $HOME/source/RMS


echo -e "\nSystem reboot..."
sudo reboot
