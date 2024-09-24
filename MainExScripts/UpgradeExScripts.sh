#!/bin/bash

# Script for updates all scripts from GitHub repository/

SAVE_CONFIG_FOLDER=$HOME/.ExScriptsConfigs


save_configs() {
	echo "Step 1 of 3. Save configs"
	mkdir --parents $SAVE_CONFIG_FOLDER
	cp --preserve --update $HOME/source/ExScripts/Starvisor/.starvisor.cfg $SAVE_CONFIG_FOLDER
	cp --preserve --update $HOME/source/ExScripts/UpArchives/.uparchives.cfg $SAVE_CONFIG_FOLDER
	cp --preserve --update $HOME/source/ExScripts/UploadCSV/.up_csv.cfg $SAVE_CONFIG_FOLDER
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
	cp --preserve --update $SAVE_CONFIG_FOLDER/.starvisor.cfg $HOME/source/ExScripts/Starvisor
	cp --preserve --update $SAVE_CONFIG_FOLDER/.uparchives.cfg $HOME/source/ExScripts/UpArchives
	cp --preserve --update $SAVE_CONFIG_FOLDER/.up_csv.cfg $HOME/source/ExScripts/UploadCSV
}


main() {
	echo "Upgrade external scripts"
	save_configs
	update_scripts
	return_configs
	echo -e "\n"
}

main

exit 0
