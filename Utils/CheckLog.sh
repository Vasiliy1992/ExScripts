#!/bin/bash

# Number of lines of the current log to display
N=100


get_log_dir(){
	log_fold="$HOME/RMS_data/"$(awk \
					'/^log_dir:/{print $2}'\
					 $HOME/source/RMS/.config\
	)
	echo $log_fold
}


get_current_log(){
	log=$(\
		ls --sort=time $log_fold/* \
		| head -1\
	)
	echo $log
}


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
