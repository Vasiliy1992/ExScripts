#!/bin/bash

########################
# Camera Reboot Script #
########################

# Old distribution of RPi3
OLD_DIST='"Raspbian GNU/Linux 8 (jessie)"'

# Activate RMS
cd $HOME/source/RMS
source $HOME/vRMS/bin/activate

# Read the current computer's distribution
DIST="$(cat /etc/os-release | awk -F"=" '/^PRETTY_NAME/{print $2}')"

#echo -e "Older distribution:\t" $OLD_DIST
#echo -e "Installed distribution:\t" $DIST

# Compare versions and run supported script
if [ "$DIST" = "$OLD_DIST" ]; then
#	echo "Old"
	echo -e "\nCamera reboot..."
	python -m Utils.CameraControl27 reboot
else
#	echo "New"
	python3 -m Utils.CameraControl reboot
fi

exit 0
