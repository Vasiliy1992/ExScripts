#!/bin/bash

#############################################
# Script for viewing the current log on SSH #
#############################################

# Number of lines of the current log to display
N=100


# Get path to log folder from configuration file
get_log_dir(){
	log_fold="$HOME/RMS_data/"$(awk \
					'/^log_dir:/{print $2}'\
					 $HOME/source/RMS/.config\
	)
#	echo $log_fold
}


# Get path to current log
get_current_log(){
	log=$(\
		ls --sort=time $log_fold/* \
		| head -1\
	)
#	echo $log
}


# Display information about the current log
disp_info(){
	clear
	echo -e "\n\tOpen current log:
	\n\t$log
	======================================================================\n"
}


# Display last N lines of current log
disp_log_lines(){
	tail \
		--follow \
		--lines=$N \
		$log
}


main(){
	get_log_dir
	get_current_log
	disp_info
	disp_log_lines
}


main

exit 0
