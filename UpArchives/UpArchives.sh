#!/bin/bash

################################################################
# Uploading archives to FTP storage.			       #
# Uploading reports on the station status to the same storage. #
################################################################

source $(dirname $0)/.uparchives.cfg

up_archive(){
	rsync \
		--archive \
		--compress \
		--protocol=29 \
		--progress \
		--stats \
		--update \
				$HOME/RMS_data/ArchivedFiles/*.tar.bz2 \
				$SERVER:/home/srmn/archives/$ID
}


up_report(){
	rsync \
		--archive \
		--verbose \
			$HOME/RMS_data/*_fits_counts.txt \
			$SERVER:/home/srmn/reports
}


main(){
	date
	up_archive
	up_report
}

main

exit 0

