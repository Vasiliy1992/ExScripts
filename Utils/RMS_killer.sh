#!/bin/bash
echo "Killed RMS"
sudo pkill -9 -f "RMS" "ffmpeg"
sudo pkill -9 -f "ffmpeg"
exit 0
