#!/bin/bash

############################################################################
# Script for viewing the current log on SSH				   #
# 2026.07.13 The script has been improved with the help of AI:		   #
# a verification mode has been added:					   #
# it can be launched by the user from the terminal or by the parent script #
############################################################################


# Number of lines of the current log to display
N=1000


# Get path to log folder from configuration file
get_log_dir(){
        log_fold="$HOME/RMS_data/"$(awk \
                                        '/^log_dir:/{print $2}'\
                                         $HOME/source/RMS/.config\
        )
}


# Get path to current log
get_current_log(){
	log=$(\
		ls --sort=time $log_fold/log_*.log \
		| head -1\
	)
#	echo $log
}


# Display information about the current log
disp_info(){
        # We clear the screen only if the script is run by a person in the terminal
        if [ -t 1 ]; then
                clear
                echo -e "
		Open current log:
                $log
                ======================================================================\n"
        fi
}


# Display last N lines of current log
disp_log_lines(){
        # Checking if the output is connected to the terminal (human trigger)
        if [ -t 1 ]; then
                # For humans: monitor the log in real time
                tail --follow --lines=$N "$log"
        else
                # For the robot: just give the last N lines and exit
                tail --lines=$N "$log"
        fi
}


main(){
        get_log_dir
        get_current_log
        disp_info
        disp_log_lines
}


main


exit 0
