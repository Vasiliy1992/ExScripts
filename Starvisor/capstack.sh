#!/bin/bash

###############################################################
# Uploading the captured stack to the Starvisor website page. #
###############################################################

# Get values from config file
source $(dirname $0)/.starvisor.cfg

echo -e "Working: directory: \n$1\n"

# Captured stack pattern
capstack="$1/*_captured_stack.jpg"

# Get station id
id=$(echo $2 | tr '[:upper:]' '[:lower:]')

# Upload a stack to site
ftp-upload \
		--verbose \
		--host $FTP_LIVE \
		--user $USER_LIVE \
		--password $PASSWD_LIVE \
		--passive \
		--as $id'.jpg' \
			$capstack

exit 0

