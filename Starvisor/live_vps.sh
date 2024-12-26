#!/bin/bash

#####################################################################
# Uploading the current FF file to the Starvisor website page	    #
# Uploading the current FF file to the server to create timelapses  #
#####################################################################

# Get values from config file
source $(dirname $0)/.starvisor.cfg

# Path to image
live=$HOME/RMS_data/live.jpg


# Upload to site
ftp-upload \
	--verbose \
	--host $FTP_LIVE \
	--user $USER_LIVE \
	--password $PASSWD_LIVE \
	--as $ID'.jpg' \
		$live


# Server data for storing archive
IMG=$(date +%Y-%m-%dT%H-%M-%S)

# Upload file to archive
ftp-upload \
	--verbose \
	--host $FTP_VPS \
	--user $USER_VPS \
	--password $PASSWD_VPS \
	--dir $ID \
	--as $IMG'.jpg' \
		$live

exit 0
