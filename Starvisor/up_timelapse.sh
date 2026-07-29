#!/bin/bash

#####################################################
# Uploading the timelapse to the Starvisor website. #
#####################################################

# Timelapse folder in FTP storage
TIMELAPSE_DIR="timelapses"

# Get values from config file
source $(dirname $0)/.starvisor.cfg


echo -e "Working: directory: \n$1\n"

# Timelapse pattern
timelapse="$1/$(basename $1)_timelapse.mp4"

echo -e "Uploading timelapse: \n${timelapse}\n"

# Upload timelapse
ftp-upload \
        --verbose \
        --host $FTP_VPS \
        --user $USER_VPS \
        --password $PASSWD_VPS \
        --dir $TIMELAPSE_DIR \
	      $timelapse

exit 0
