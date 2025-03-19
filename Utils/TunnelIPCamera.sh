#!/bin/bash

# Camera IP
IP=$( \
	cat \
		$HOME/source/RMS/.config | \
					grep \
						--only-matching \
						--max-count 1 \
								"192.*.*.*:554" | \
										head \
											--bytes -5\
													 )

echo "Camera IP: $IP"

echo "Tunneling camera ports to RPi public ports..."

# Media port
socat tcp-listen:34567,reuseaddr,fork tcp:$IP:34567 &

# Onvif port
socat tcp-listen:8899,reuseaddr,fork tcp:$IP:8899 &

# Http port
sudo socat tcp-listen:80,reuseaddr,fork tcp:$IP:80 &

# RTSP port
sudo socat tcp-listen:554,reuseaddr,fork tcp:$IP:554 &

# RTSP port
sudo socat UDP4-RECVFROM:554,reuseaddr,fork UDP4-SENDTO:$IP:554 &

read -p "Press any key to stop tunnelling..."
killall socat
$SHELL
