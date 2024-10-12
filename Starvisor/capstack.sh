#!/bin/bash

###############################################################
# Uploading the captured stack to the Starvisor website page. #
# Removing incorrect temporary files.			      #
###############################################################

source $(dirname $0)/.starvisor.cfg

echo "Working: directory: $1"

# Captured stack pattern
image="$1/*_captured_stack.jpg"

# Name for temporary file
stack="$1/$ID.jpg"

# Create a temporary file
cp $image $stack

# Uploading a temporary file to the server
ftp-upload \
		--verbose \
		--host $FTP_LIVE \
		--user $USER_LIVE \
		--password $PASSWD_LIVE \
		--passive \
			$stack

# Delete temporary file
rm $stack

# Delete incorrect temporary files
find \
	~/RMS_data \
	-maxdepth 1 \
	-type f \
	-name "*T*.jpg" \
	-delete

exit 0

