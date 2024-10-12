#!/bin/bash

#####################################################################
# Uploading the current FF file to the Starvisor website page.	    #
# Uploading the current FF file to the server to create timelapses. #
# Creating a folder with FF files on the current PC (optional).	    #
#####################################################################

source $(dirname $0)/.starvisor.cfg


#Server data for storing archive
IMG=$(date +%Y-%m-%dT%H-%M-%S)


up_to_site(){
	#New image name
	upload=$home/RMS_data/$ID'.jpg'

	#Copy file with new name
	cp $home/RMS_data/live.jpg $upload

	#Upload to site
	ftp-upload \
		--verbose \
		--host $FTP_LIVE \
		--user $USER_LIVE \
		--password $PASSWD_LIVE \
		--passive $upload
}


up_to_archive(){
	#New image name
	archive=$home/RMS_data/$IMG'.jpg'

	#Copy file with new name
	cp $home/RMS_data/live.jpg $archive

	#Upload file to archive
	ftp-upload \
		--verbose \
		--host $FTP_VPS \
		--user $USER_VPS \
		--password $PASSWD_VPS \
		--passive \
		--dir $ID $archive
}


live_archive(){
	#Check flag
	if [ "$flag" == true ];	then
		#Creale live_archive folder
		live_archive=$home/RMS_data/live_archive/$(date +%Y-%m-%d)
		mkdir --parents $live_archive
		mv $archive $live_archive
	else
		#Remove file
		rm $archive
	fi
}


main(){
	up_to_site
	up_to_archive
	live_archive
}

main

exit 0

