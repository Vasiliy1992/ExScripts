#!/bin/bash

# Script for extracting CSV files from archives with sorting and uploading to cloud storage

source $(dirname $0)/.up_csv.cfg

csv_list() {
	# csv_list [CSV FOLDER] [LIST FOLDER]
	# arch_list return:  csv.list 		list with csv files
	#		     csv_index.list	list with index of csv files
	cd $1
	find . -maxdepth 3 -name '*.csv' | sort > $2/csv.list
	for elem in $(cat $2/csv.list)
		do
			echo ${elem:15:-4} >> $2/csv_index.list
		done
}

arch_list() {
	# arch_list [ARCH FOLDER] [LIST FOLDER]
	#arch_list return:  arch.list 		list with archives
	#		    arch_index.list	list with index of archives
	cd $1
	find . -maxdepth 1 -name '*.tar.bz2' | sort > $2/arch.list
	for arch in $(cat $tempFold/arch.list)
		do
			echo ${arch:2:-17} >> $2/arch_index.list
		done
}

extract_csv() {
	# extract_csv [ARCHIVE FOLDER] [PARTH TO FILES] [PATH TO LIST]
	mkdir -p $2
	echo -e "\nExtracting csv files from the following archives:"
	for string in $(cat $3)
		do
			archive=$string"_detected.tar.bz2"
			echo $archive
			csv="./"$string".csv"
			tar -xf $1/$archive $csv
		done
	echo "Extracting complete."
}

sort_csv_files() {
	# sort_csv_files [PARTH TO CSV-FOLDER] [DESTINATION FOLDER]
	# sort by year and months
	cd $1
	echo -e "\nSorting files in the $2 folder"
	for file in $(find *.csv)
		do
			Year=${file:7:-22}
			Month=${file:11:-20}
			mkdir -p $2/$Year/"$Month"_"$Year"
			cp -rf $file $2/$Year/"$Month"_"$Year"
			echo "File $file moved to folder "$Year"/"$Month"_"$Year""
		done
}

sort_csv_files_2() {
	# sort_csv_files [PARTH TO CSV-FOLDER] [DESTINATION FOLDER]
	# sort by year, id and months
	cd $1
	echo -e "\nSorting files in the $2 folder"
	for file in $(find *.csv)
		do
			Year=${file:7:-22}
			ID=${file:0:-27}
			Month=${file:11:-20}
			mkdir -p $2/$Year/"$Month"_"$Year"/"$ID"_"$Month"_"$Year"
			cp -rf $file $2/$Year/"$Month"_"$Year"/"$ID"_"$Month"_"$Year"
			echo "File $file moved to folder" "$ID"_"$Month"_"$Year"
		done
}

form_csv_fold() {

	mkdir $tempFold
	mkdir -p $CSV/added
	mkdir -p $CSV/upload

	#create lists
	csv_list $CSV $tempFold
	arch_list $ARCH $tempFold

	cd $tempFold

	# Checking for csv files and archives for unpacking
	if [ -s ./csv.list ] && [ -s ./arch.list ]; then

		# If the files and archives exist, then:

		# Getting a list of unique archives
		grep -v -f ./csv_index.list ./arch_index.list > uniq_arch.list

		if [ -s ./uniq_arch.list ]; then
			# If there are elements in the list of unique archives, then:
			echo -e "\n \n"
			extract_csv $ARCH $tempFold $tempFold/uniq_arch.list
		else
			#If the list of unique archives is empty:
			echo -e "\nNew archives not found. \nClose script..."
			# Delete temporary folders with files
			rm -rf $tempFold
			rm -rf $CSV/added
			rm -rf $CSV/upload
			exit 0
		fi

	# If the list of files or the list of archives is empty, then
	elif [ -s ./arch.list ]; then
		# If the list of archives is not empty, then:
		echo -e "\nCSV folder not found!"
		extract_csv $ARCH $tempFold $tempFold/arch_index.list
	else
		# If the list of archives is empty:
		echo -e "\nArchivedFiles not found! \nClose script..."
		# Delete temporary folders with files
		rm -rf $tempFold
		rm -rf $CSV/added
		rm -rf $CSV/upload
		exit 0
	fi

	sort_csv_files $tempFold $CSV/added
	cp -rf $CSV/added/* $CSV

	sort_csv_files_2 $tempFold $CSV/upload
}

upload_files() {
	echo -e "Uploading csv-files..."
	echo $line
	python3 ~/source/ExScripts/UploadCSV/RMS_up_YD.py $YDfold $CSV/upload $YDtoken
	# python3 [SCRIPT] [CLOUD_FOLDER] [LOCAL_FOLDER] [TOKEN]
	echo $line
	python ~/source/ExScripts/UploadCSV/RMS_up_Dx.py $Dxfold $CSV/upload $APP_KEY $SECRET_KEY $REFRESH_TOKEN
	# python3 [SCRIPT] [CLOUD_FOLDER] [LOCAL_FOLDER] [APP_KEY] [SECRET_KEY] [REFRESH_TOKEN]
}

del_temp() {
	# Delete temporary folders with files
	rm -rf $tempFold
	rm -rf $CSV/added
	rm -rf $CSV/upload
}

logger() {
	# logger [MAIN_FUNC] [LOG_DIR]
	Name=$(basename "$0" | sed 's/\.[^.]*$//')
	now=$(date +%F_%T)
	mkdir -p $2
	$1 2>&1 | tee $2/$Name.$now.log
}

main_func() {
	del_temp
	form_csv_fold
	upload_files
	del_temp
}

#logger main_func $LogDir

main_func

exit 0
