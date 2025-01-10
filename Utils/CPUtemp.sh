#!/bin/bash

# Raspberry Pi CPU Temperature Monitoring Script
# To activate, grant execution rights and write the script in crontab:
#
#	sudo nano /etc/crontab
#
# Add the following lines to the end of the file (run the script every 5 minutes):
#
# */5 *	* * *	pi	/home/pi/source/ExScripts/Utils/CPUtemp.sh
#
# ===============================================
# | Fix username: rms on Raspberry Pi4 Bullseye!|
# ===============================================
#
# View current temperature values:
#
#	tail -n 50 $(ls -t ~/RMS_data/logs/CPUtemp | head -1)
#
# For convenience, you can create an alias.


# Folder for writing logs
LOG_DIR="$HOME/RMS_data/logs/CPUtemp"


# Get current date and time
dt=$(date '+%d/%m/%Y %H:%M:%S')

# Get CPU temperature value
tm=$(vcgencmd measure_temp | cut -d= -f2)

# Create a log folder if it doesn't exist
mkdir --parents $LOG_DIR

# Write the temperature value to a log file in the folder $LOG_DIR
echo $dt $tm  >> $LOG_DIR/temperature-$(date +%Y%m%d).log

exit 0
