#!/bin/bash

source $(dirname $0)/.starvisor.cfg

#Station id
#ID=$(hostname | tr [:upper:] [:lower:])

#Server data for storing archive
IMG=$(date +%Y-%m-%dT%H-%M-%S)


up_to_site(){
	#New image name
	upload=$home/RMS_data/$ID'.jpg'
	#Copy file with new name
	cp $home/RMS_data/live.jpg $upload
	#Upload to site
	ftp-upload -v -h $FTP_LIVE -u $USER_LIVE --password $PASSWD_LIVE --passive $upload
}

up_to_archive(){
	#New image name
	archive=$home/RMS_data/$IMG'.jpg'
	#Copy file with new name
	cp $home/RMS_data/live.jpg $archive
	#Upload file to archive
	ftp-upload -v -h $FTP_VPS -u $USER_VPS --password $PASSWD_VPS --passive --dir $ID $archive
}

live_archive(){
	#Check flag
	if [ "$flag" == true ];	then
		#Creale live_archive folder
		live_archive=$home/RMS_data/live_archive/$(date +%Y-%m-%d)
		mkdir -p $live_archive
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