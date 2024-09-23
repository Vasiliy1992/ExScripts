#!/bin/bash

source $(dirname $0)/.uparchives.cfg


up_archive(){
	rsync \
		--archive \
		--verbose \
		--protocol=29 \
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
