#!/bin/bash

########################################################################################################
echo -e "\n Script for extracting CSV files from archives with sorting and uploading to cloud storage\n"
########################################################################################################

# The script receives three arguments:
# $1 - path to the CapturedFiles folder;
# $2 - path to the ArchivedFiles folder;
# $3 - camera number ID.


# Path to the current script
LOCATION=$(dirname $(readlink --canonicalize $0))

# Read the configuration file
source $LOCATION/.up_csv.cfg


csv_list() {
	# csv_list CSV_FOLDER LIST_FOLDER
	# csv_list return:	csv_index.list		list with index of csv files

	if [ -d $1 ]; then

		find $1 \
			-maxdepth 4 \
			-name '*.csv' \
			-exec basename {} .csv \; | \
							sort >> "$2/csv_index.list"
	else
		echo -e "\nFolder $1 not exist! CSV-files do not uploaded.\n"
	fi
}


fold_list() {
	# fold_list ARCH_FOLDER LIST_FOLDER
	# fold_list return:	fold_index.list	list with index of folders


	find $1 \
		-maxdepth 1 \
		-type d \
		-name '*_*_*_*' \
		-exec basename {} \; | \
					sort > "$2/fold_index.list"
}


arch_list() {
	# arch_list ARCH_FOLDER LIST_FOLDER
	# arch_list return:	arch_index.list	list with index of archives


	find $1 \
		-maxdepth 1 \
		-name '*.tar.bz2' \
		-exec basename {} _detected.tar.bz2 \; | \
							sort > $2/arch_index.list
}


cp_csv() {
	# cp_csv ARCHIVE_FOLDER OUTPUT_FOLDER PATH_TO_LIST
	# Copies csv files from PATH_TO_LIST contained in ARCHIVE_FOLDER to OUTPUT_FOLDER.

	cd $1
	mkdir --parents $2

	echo -e "\nCopy csv-files from the following folders:"
	cat $3
	echo ''

	for fold_index in $(cat $3)
		do
			csv="./"$fold_index"/"$fold_index".csv"
			echo "Copy $csv to $2"
			cp $csv $2
		done
	echo -e "\nCopying completed!"

	cd $OLDPWD
}


extract_csv() {
	# extract_csv ARCHIVE_FOLDER OUTPUT_FOLDER PATH_TO_LIST
	# Extracts csv files from archives in the ARCHIVE_FOLDER folder according to the PATH_TO_LIST list and copies the moved files to OUTPUT_FOLDER.

	cd $1
	mkdir --parents $2

	echo -e "\n\nExtracting csv files from the following archives:"
	cat $3
	echo ''

	for string in $(cat $3)
		do
			archive=$string"_detected.tar.bz2"
			csv="./"$string".csv"

			echo "Extraction: $csv to $2"

			tar \
				--extract \
				--file=$1/$archive \
				--directory=$2 \
				$csv
		done
	echo -e "\nExtracting completed!"
	cd $OLDPWD
}


sort_csv_for_rpi() {
	# sort_csv_for_rpi PARTH_TO_CSV-FOLDER DESTINATION_FOLDER
	# sort by year and months

	cd $1

	mkdir --parents $2
	echo -e "\n\nSorting files in the $1 folder for $2 folder"

	for file in $(find *.csv)
		do
			ID=${file:0:-27}
			Year=${file:7:-22}
			Month=${file:11:-20}

			mkdir --parents $1/added/$ID/$Year/"$Month"_"$Year"
			cp --recursive --force $file $1/added/$ID/$Year/"$Month"_"$Year"
			echo "File $file moved to folder "$ID/$Year"/"$Month"_"$Year""
		done

	echo -e "\nCopy csv files to a local folder for storage: $2"
	cp --force --recursive $1/added/* $2

	cd $OLDPWD
}


sort_csv_for_cloud() {
	# sort_csv_for_cloud PARTH_TO_CSV-FOLDER DESTINATION_FOLDER
	# sort by year, months and id

	cd $1
	mkdir --parents $2

	echo -e "\n\nSorting files in the $1 folder for upload"

	for file in $(find *.csv)
		do
			Year=${file:7:-22}
			ID=${file:0:-27}
			Month=${file:11:-20}

			mkdir --parents $1/upload/$Year/"$Month"_"$Year"/"$ID"_"$Month"_"$Year"
			cp --recursive --force $file $1/upload/$Year/"$Month"_"$Year"/"$ID"_"$Month"_"$Year"
			echo "File $file moved to folder" "$ID"_"$Month"_"$Year"
		done

	echo -e "\nSorting completed!\n\n"
	cd $OLDPWD
}


cp_fold_csv() {

	# Create list of folders
	fold_list $ARCH $tempFold

	cd $tempFold

	if [ -s ./csv_index.list ] && [ -s ./fold_index.list ]; then

		# Getting a list of unique folders
		grep --invert-match --file ./csv_index.list ./fold_index.list > uniq_fold.list

		if [ -s ./uniq_fold.list ]; then
			# Copy csv from folders
			cp_csv $ARCH $tempFold $tempFold/uniq_fold.list

			# Add folder list to csv list (copied to already copied)
			cat uniq_fold.list >> ./csv_index.list
		else
			echo -e "\nNew folders not found."
		fi
	elif [ -s ./fold_index.list ]; then
		#echo -e "\nCSV folder not found!"
		# Copy csv from folders
		cp_csv $ARCH $tempFold $tempFold/fold_index.list

		# Add folder list to csv list (copied to already copied)
		cat fold_index.list >> ./csv_index.list
	else
		echo -e "\nFolders not found."
	fi
}


ex_arch_csv() {
	#create archive list
	arch_list $ARCH $tempFold

	cd $tempFold

	if [ -s ./csv_index.list ] && [ -s ./arch_index.list ]; then
		# Getting a list of unique archives
		grep --invert-match --file ./csv_index.list ./arch_index.list > uniq_arch.list

		if [ -s ./uniq_arch.list ]; then
			# Extracting csv from archives
			extract_csv $ARCH $tempFold $tempFold/uniq_arch.list
		else
			echo -e "\n\nNew archives not found."
		fi

	elif [ -s ./arch_index.list ]; then
		#echo -e "\nCSV folder not found!"
		# Extracting csv from archives
		extract_csv $ARCH $tempFold $tempFold/arch_index.list
	else
		echo -e "\nArchivedFiles not found!"
	fi
}


upload_files() {
	echo -e "Uploading csv-files..."
	echo $line
	python3 $LOCATION/RMS_up_YD.py $YDfold $tempFold/upload $YDtoken
	# python3 SCRIPT CLOUD_FOLDER LOCAL_FOLDER TOKEN

	# Yandex Disk upload script completion code
	EXIT_CODE_YD=$?

	echo $line
	python $LOCATION/RMS_up_Dx.py $Dxfold $tempFold/upload $APP_KEY $SECRET_KEY $REFRESH_TOKEN
	# python3 SCRIPT CLOUD_FOLDER LOCAL_FOLDER APP_KEY SECRET_KEY REFRESH_TOKEN

	# Dropbox upload script completion code
	EXIT_CODE_DX=$?

	# Exit the program if any boot script terminates abnormally
	if [[ $EXIT_CODE_YD -ne 0 || $EXIT_CODE_DX -ne 0 ]]; then
		echo -e "\nWARNING! ERROR UPLOADING FILES!\n"
		rm --recursive --force $tempFold
		exit 1
	fi
}


logger() {
	# logger MAIN_FUNC LOG_DIR
	Name=$(basename "$0" | sed 's/\.[^.]*$//')
	now=$(date +%F_%T)
	mkdir --parents $2
	$1 2>&1 | tee $2/$Name.$now.log
}


main_func() {

	# Deleting temporary folders is necessary if the script was interrupted
	rm --recursive --force $tempFold

	if [ -d $ARCH ]; then

		# Creating temporary folder
		mkdir --parents $tempFold

		# Creating a list of uploaded csv files
		csv_list $CSV $tempFold

		# Copying csv files from folders
		cp_fold_csv

		# Extracting csv files from archives
		ex_arch_csv

		# Number of csv files in temporary folder
		temp_CSV=$(find \
				$tempFold \
				-type f \
				-name "*.csv" | \
						wc --lines)

		# Check for csv files in the temporary folder
		if [ "$temp_CSV" -eq 0 ]; then
			echo -e "\nThe number of new csv files is equal $temp_CSV. Close script."
		else
			# Sorting csv files for uploading to cloud storage
			sort_csv_for_cloud $tempFold $tempFold/upload

			# Uploading csv files to cloud storage
			upload_files

			# Sorting dsv files for storage at the station
			sort_csv_for_rpi $tempFold $CSV
		fi

		# Deleting temporary folders after finishing work
		rm --recursive --force $tempFold
	else
		echo -e "$ARCH\nNot exist! Close script..."
		exit 0
	fi
}


if [ "$LOGGING" = true ]; then
	logger main_func $LogDir
else
	main_func
fi

exit 0
