#!/bin/bash

source $(dirname $0)/.starvisor.cfg

#Path of the last directory with captured files
path=$(\
	ls \
		-t\
		--directory $HOME/RMS_data/CapturedFiles/* \
		| head -n 1\
	)

#Captured stack pattern
image=$path/*_captured_stack.jpg

#Name for temporary file
stack=$path/$ID.jpg

#Create a temporary file
cp $image $stack

#Uploading a temporary file to the server
ftp-upload \
		--verbose \
		--host $FTP_LIVE \
		--user $USER_LIVE \
		--password $PASSWD_LIVE \
		--passive \
			$stack

#Delete temporary file
rm $stack

#Delete incorrect temporary files
find \
	~/RMS_data \
	-maxdepth 1 \
	-type f \
	-name "*T*.jpg" \
	-delete

exit 0
