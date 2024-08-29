#!/bin/bash

# Script for updates all scripts from GitHub repository/

SAVE_CONFIG_FOLDER=$HOME/.ExScriptsConfigs
SCRIPT_FOLDER=$(dirname $0)


save_configs() {
	echo "Step 1 of 3. Save configs"
	mkdir $SAVE_CONFIG_FOLDER 2>/dev/null
	cp "$SCRIPT_FOLDER/Starvisor/.starvisor.cfg" $SAVE_CONFIG_FOLDER
	cp "$SCRIPT_FOLDER/UpArchives/.uparchives.cfg" $SAVE_CONFIG_FOLDER
	cp "$SCRIPT_FOLDER/UploadCSV/.up_csv.cfg" $SAVE_CONFIG_FOLDER
}


update_scripts() {
	echo "Step 2 of 3. Upgrade scripts."
	cd $(dirname $0)
	# Stash the cahnges
	git stash
	# Pull new code from github
	git pull
	cd -
}


return_configs() {
	echo "Step 3 of 3. Return configs"
	cp --force "$SAVE_CONFIG_FOLDER/.starvisor.cfg" "$SCRIPT_FOLDER/Starvisor"
	cp --force "$SAVE_CONFIG_FOLDER/.uparchives.cfg" "$SCRIPT_FOLDER/UpArchives"
	cp --force "$SAVE_CONFIG_FOLDER/.up_csv.cfg" "$SCRIPT_FOLDER/UploadCSV"
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

