#!/bin/bash

##################################################
# Running postprocess scripts (external scripts) #
##################################################

# CapturedFiles folder
capt=$1

# ArchivedFiles folder
arch=$2

# Station ID
ID=$3

# Folder for writing logs
LOG_DIR="$HOME/RMS_data/logs/ExScript"


# Host for checking internet connection
CHECK_HOST="8.8.8.8"

# Internet connection wait time
WAIT_TIME=1800


# Folder with scripts location
LOCATION=$(dirname \
		$(readlink \
			--canonicalize $0)\
						)"/../.."


print_logo() {
	figlet -ckt "RMS EXTERNAL SCRIPT"
	printf "STARTING EXTERNAL SCRIPT ...\n"
}


rmsExternal() {

	printf "\nCurrent captured dir: \n$capt \n==============================================================\n"

	printf "\n\n1. Reboot camera\n================\n"
	"$LOCATION/ExScripts/Utils/CameraReboot.sh"

	printf "\n\n2. Upload CapturedStack to www.starvisor.ru\n===========================================\n"
	"$LOCATION/ExScripts/Starvisor/capstack.sh" $capt $ID

	printf "\n\n3. Upload csv-files to cloud storages\n=====================================\n"
	"$LOCATION/ExScripts/UploadCSV/UploadCSV.sh"

	printf "\n\n4. Upload archives to FTP-storage\n=================================\n"
	"$LOCATION/ExScripts/UpArchives.sh" $ID

	printf "\n\n5. Upload report\n=================================\n"
	"$LOCATION/ExScripts/UpSummary.sh" $arch $ID

	printf "\n\n6. Cleaning up old logs\n=======================\n"
	"$LOCATION/ExScripts/Utils/ClearLogs.sh"

	# Write uptime
	"$LOCATION/ExScripts/Utils/Uptime_logger.sh"

}


ck_internet() {
	# Endless waiting cycle
	while true; do
		echo "Checking internet connection ..."
		if ping -c 5 "$CHECK_HOST" &> /dev/null; then
			echo "Internet connection established!"
			print_logo
			rmsExternal
			break
		fi
		echo "Internet connection not established! Waiting $WAIT_TIME seconds."
		sleep $WAIT_TIME
	done
}


logger() {
	# Usage: logger [MAIN_FUNC] [LOG_DIR]
	# Get name withort format
	Name=$(basename "$0" | sed 's/\.[^.]*$//')
	# Get current datetime
	now=$(date +%F_%T)
	# Create log folder
	mkdir --parents $2
	# Execute script
	$1 2>&1 | tee $2/$Name.$now.log
}


main() {
	ck_internet
}


logger main $LOG_DIR


exit 0
