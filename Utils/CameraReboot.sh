#!/bin/bash

########################
# Camera Reboot Script #
########################

echo "Camera reboot..."

# Activate RMS
cd $HOME/source/RMS
source $HOME/vRMS/bin/activate

python3 -m Utils.CameraControl reboot
