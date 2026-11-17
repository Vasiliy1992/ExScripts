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
HOST1="starvisor.ru"
HOST2="ya.ru"
HOST3="dropbox.com"
HOST4='ru000q'

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
        local step=0
        local line=$(printf '%60s' '' | tr ' ' '=')

        print_step() {
                step=$((step + 1))
                printf "\n\n%d. %s\n%s\n" "$step" "$1" "$line"
        }

        printf "\nCurrent captured dir: \n%s\n%s\n" "$capt" "$line"

        print_step "Reboot camera"
        "$LOCATION/ExScripts/Utils/CameraReboot.sh"

#        print_step "Upload CapturedStack to www.starvisor.ru"
#        "$LOCATION/ExScripts/Starvisor/capstack.sh" "$capt" "$ID"

#        print_step "Uploading a timelapse to the Starvisor project server"
#        "$LOCATION/ExScripts/Starvisor/up_timelapse.sh" "$arch"

        print_step "Upload csv-files to cloud storages"
        "$LOCATION/ExScripts/UploadCSV/UploadCSV.sh"

        print_step "Upload archives to FTP-storage"
        "$LOCATION/ExScripts/UpArchives.sh" "$ID"

        print_step "Upload report"
        "$LOCATION/ExScripts/UpSummary.sh" "$arch" "$ID"

        print_step "Cleaning up old logs"
        "$LOCATION/ExScripts/Utils/ClearLogs.sh"
}


ck_internet() {
	# Endless waiting cycle
	while true; do
		echo "Checking internet connection ..."
		if ping -c 5 "$HOST1" &> /dev/null || \
		   ping -c 5 "$HOST2" &> /dev/null || \
		   ping -c 5 "$HOST3" &> /dev/null || \
		   ping -c 5 "$HOST4" &> /dev/null;
		then
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
