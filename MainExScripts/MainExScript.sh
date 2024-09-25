#!/bin/bash

LOG_DIR="$HOME/RMS_data/logs/ExScript"


print_logo() {
	figlet \
		-c \
		-k \
		-t \
			"RMS EXTERNAL SCRIPT"
	printf "STARTING EXTERNAL SCRIPT...\n"
}


last_dir() {
	#Last CaptutedFiles folder
	capt=$(\
            ls \
                -t \
                --directory \
                             $HOME/RMS_data/CapturedFiles/* \
                                                                 | head -1
                                                                           )
    printf "\nLatest captured dir: \n$capt \n=============================================================\n"
}


rmsExternal() {
	printf "\n\n1. Reboot camera\n================\n"
	"$HOME/source/ExScripts/Utils/CameraReboot.sh"

	printf "\n\n2. Upload CapturedStack to www.starvisor.ru\n===========================================\n"
	"$HOME/source/ExScripts/Starvisor/capstack.sh"

	printf "\n\n3. Upload csv-files to cloud storages\n=====================================\n"
	"$HOME/source/ExScripts/UploadCSV/Extract_CSV.sh"

	printf "\n\n4. Starting Check_and_Clean\n===========================\n"
	"$HOME/source/ExScripts/RMS_extra_tools/Check_and_Clean.sh" $1

	printf "\n\n5. Upload archives to FTP-storage\n=================================\n"
	"$HOME/source/ExScripts/UpArchives/UpArchives.sh"

	printf "\n\n6. Reboot RPi...\n"
	sudo reboot
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
	print_logo
	last_dir
	rmsExternal $capt
}


logger main $LOG_DIR

exit 0
