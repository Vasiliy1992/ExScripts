#!/bin/bash
#Reading the latest log
log_path=~/RMS_data/logs/RMS_logs
log=$(ls -t $log_path/* | head -1)
echo ""
echo "Open current log:"
echo $log
echo "============================================================"
echo ""
tail -f $log
