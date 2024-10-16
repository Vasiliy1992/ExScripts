#!/bin/bash

#########################################################
# Script for updates all scripts from GitHub repository #
#########################################################

SAVE_CONFIG_FOLDER=$HOME/.ExScriptsConfigs


save_configs() {
	echo "Step 1 of 3. Save changes to configs"
	mkdir --parents $SAVE_CONFIG_FOLDER
	cp $HOME/source/ExScripts/Starvisor/.starvisor.cfg $SAVE_CONFIG_FOLDER --update --preserve
	cp $HOME/source/ExScripts/UpArchives/.uparchives.cfg $SAVE_CONFIG_FOLDER --update --preserve
	cp $HOME/source/ExScripts/UploadCSV/.up_csv.cfg $SAVE_CONFIG_FOLDER --update --preserve
}


chk_save_config_fold(){
        if ! [ -d $SAVE_CONFIG_FOLDER ]; then
                echo -e "\nERROR! \nFolder: \n$SAVE_CONFIG_FOLDER\nnot exist!"
		exit 0
        else
                echo -e "\nFolder: \n$SAVE_CONFIG_FOLDER \nexist! \nGoto step 2 of 3..."
        fi
}


chk_empty_cfg() {
	# Checking for the presence of parameters in configs
	id=$(cat $HOME/source/ExScripts/Starvisor/.starvisor.cfg | awk -F"=" '/^ID/{print $2}' | tr --delete \")
	ID=$(cat $HOME/source/ExScripts/UpArchives/.uparchives.cfg | awk -F"=" '/^ID/{print $2}' | tr --delete \")
	YDtoken=$(cat $HOME/source/ExScripts/UploadCSV/.up_csv.cfg | awk -F"=" '/^YDtoken/{print $2}' | tr --delete \")
#	echo $id $ID $YDtoken

	# If there are no parameters in the config, copy from the backup folder if there is one
	if [[ "$id" == "" || "$ID" == "" || "$YDtoken" == '' ]]; then
		echo "Configs are empty! No saving required."
		chk_save_config_fold
	else
		save_configs
	fi
}


update_scripts() {
	echo "Step 2 of 3. Upgrade scripts."
	# Go to the script folder
	cd $HOME/source/ExScripts
	# Stash the cahnges
	git stash
	# Pull new code from github
	git pull
	# Go to previous directory
	cd -
}


return_configs() {
	echo "Step 3 of 3. Return configs"
	cp $SAVE_CONFIG_FOLDER/.starvisor.cfg $HOME/source/ExScripts/Starvisor  --preserve
	cp $SAVE_CONFIG_FOLDER/.uparchives.cfg $HOME/source/ExScripts/UpArchives --preserve
	cp $SAVE_CONFIG_FOLDER/.up_csv.cfg $HOME/source/ExScripts/UploadCSV --preserve
}


main() {
	echo -e "\nUpgrade external scripts\n========================================================"
	chk_empty_cfg
	update_scripts
	return_configs
	echo -e "\n"
}

main

exit 0
