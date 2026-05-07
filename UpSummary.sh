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


date

scp \
	$ARCH/"$(basename $ARCH)_observation_summary.json" \
	$SERVER:"/home/srmn/observation_reports/"$ID
exit 0

