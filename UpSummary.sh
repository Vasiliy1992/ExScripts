#!/bin/bash

################################################################
# Uploading reports on the station status to the same storage. #
################################################################


# FTP server
SERVER="SRMN"

# ArchivedFolder (input folder)
ARCH=$1

# Station ID
ID=$2

# Name of the summary file to download
SOURCE_FILE="$(basename $ARCH)_observation_summary.json"


date

scp \
	-p \
	$ARCH/$SOURCE_FILE \
	$SERVER:"/home/srmn/observation_reports/"$ID

# Checking the return code
if [ $? -eq 0 ]; then
	echo "The status report file $SOURCE_FILE has been loaded"
else
	echo "ERROR loading report file $SOURCE_FILE!"
fi

exit 0

