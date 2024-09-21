#!/bin/bash

# Path to the logs folder
log_path=~/RMS_data/logs/RMS_logs

# Number of log lines to output
N=100


# Get the full path to the last created log
log=$(\
	ls --sort=time $log_path/* \
	| head -1\
)


# Display information about the current log
clear
echo -e "\n\tOpen current log:
\n\t$log
\t======================================================================\n"


# Display current N log lines
tail \
	--follow \
	--lines=$N \
	$log

