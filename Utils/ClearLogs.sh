#!/bin/bash

#######################################
# Script for cleaning the logs folder #
#######################################

# Settings
T_SAVE=20
LOG_FOLD="$HOME/RMS_data/logs"
MAX_DEPTH=2


# Checking if a directory exists
if [ ! -d "$LOG_FOLD" ]; then
    echo "Error: Directory $LOG_FOLD does not exist!"
    exit 1
fi

# Find and delete log files older than T_SAVE days
find "$LOG_FOLD" -maxdepth "$MAX_DEPTH" -type f -mtime +"$T_SAVE" -exec rm {} \;

echo "Clearing logs older than $T_SAVE days completed!"
