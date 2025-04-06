#!/bin/bash
# Chech uptime RPi.
echo -e $(date) "\n" $(uptime) "\n" >> $HOME/RMS_data/uptime.log
exit 0
