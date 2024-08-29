#!/bin/bash
echo "Camera reboot..."
cd ~/source/RMS
source $HOME/vRMS/bin/activate
python3 -m Utils.CameraControl reboot

