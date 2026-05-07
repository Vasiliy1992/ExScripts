#!/bin/bash

#####################################
# Uploading archives to FTP storage #
#####################################


# FTP server
SERVER="SRMN"

# Station ID
ID=$1


date

rsync \
	--archive \
	--compress \
	--protocol=29 \
	--progress \
	--stats \
	--update \
		$HOME/RMS_data/ArchivedFiles/*.tar.bz2 \
		$SERVER:/home/srmn/archives/$ID
exit 0

