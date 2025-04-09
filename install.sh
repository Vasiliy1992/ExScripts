#!/bin/bash

# Automatic installation script

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #
# Tested on Raspberry Pi4 buster   #
# Tested on Raspberry Pi4 billseye #
# Tested on Raspberry Pi3 Jessie   #
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #



echo "
WARNING!
This script is experimental. It is intended for installing additional software on RMS meteor stations based on Raspberry Pi.
Before starting the installation, save all data and create a backup copy of the data.
Do you understand all the risks and want to continue the installation?
(y/n)
"
read var



case $var in
	'y')
		# Folder with configs
		SAVE_CONFIG_FOLDER=$HOME/.ExScriptsConfigs

		if ! [ -d $SAVE_CONFIG_FOLDER ]; then
			echo "Folder $SAVE_CONFIG_FOLDER does not exist! Copy the script configuration files to the specified folder!"
			exit 0
		fi


		if ! [ -d $HOME/.ssh ]; then
			echo "Folder $HOME/.ssh does not exist! Generate ssh-key!"
			exit 0
		fi



		echo -e "\n\nStep 1. Enter the provided data\n"
		read -p "Enter IP:       " IP
		read -p "Enter port:     " PORT
		read -p "Enter login:    " LOGIN
		read -s -p "Enter password: " PASSWORD
		echo " "



		echo -e "\nStep 2. Determine the version of the distribution\n"
		# Old distribution of RPi3
		JESSIE='"Raspbian GNU/Linux 8 (jessie)"'

		# Old distribution of RPi4
		BUSTER='"Raspbian GNU/Linux 10 (buster)"'

		# New distribution of RPi4
		BULLSEYE='"Debian GNU/Linux 11 (bullseye)"'

		# Read the current computer's distribution
		DIST="$(cat /etc/os-release | awk -F"=" '/^PRETTY_NAME/{print $2}')"

		echo -e "Older distribution:\t" $JESSIE "\n\t\t\t" $BUSTER
		echo -e "Installed distribution:\t" $DIST "\n"



		echo -e "\n\nStep 3. Edit the list of repositories and install the necessary packages\n"
		case $DIST in

			"$JESSIE")

				# Create a backup copy of the repository list
				sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

				# Add repositories to the list
				sudo bash -c "cat > /etc/apt/sources.list << EOF
deb http://archive.debian.org/debian/ jessie main non-free contrib
deb-src http://archive.debian.org/debian/ jessie main non-free contrib
deb http://archive.debian.org/debian-security/ jessie/updates main non-free contrib
deb-src http://archive.debian.org/debian-security/ jessie/updates main non-free contrib
EOF"

				# Update package list
				sudo apt-get install debian-archive-keyring
				sudo apt-get update

				# Install python libraries
				pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org dropbox

				# Install supported library Yandex-disk
				cd ~/source
				git clone https://github.com/ivknv/yadisk
				cd yadisk
				git checkout 45652154d017f8bc62a0ecc5079b0379a33a9689
				sudo python3 setup.py install

				# Install entr from sources
				cd ~/source
				git clone https://github.com/eradman/entr.git
				cd entr
				./configure
				make test
				sudo make install

				# Install other packages
				sudo apt install bc figlet ftp-upload
			;;


			"$BUSTER")

				# Create a backup copy of the repository list
				sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

				# Add repositories to the list
				sudo bash -c "cat >> /etc/apt/sources.list << EOF
deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi
EOF"

				# Update package list
				sudo apt-get update

				# Install python libraries
				pip install dropbox
				pip3 install yadisk

				# Install other packages
				sudo apt install entr figlet ftp-upload
			;;


			"$BULLSEYE")

				# Update package list
				sudo apt-get update

				# Install python libraries
				pip install dropbox
				pip3 install yadisk

				# Install other packages
				sudo apt install entr figlet ftp-upload
			;;

			*)
				echo -e "\nUnknown distribution! Exit."
				exit 0
			;;
		esac



		echo -e "\n\nStep 4. Copy configs for ExScripts\n"
		# Copy configes
		cp --verbose $SAVE_CONFIG_FOLDER/.starvisor.cfg $HOME/source/ExScripts/Starvisor  --preserve
		cp --verbose $SAVE_CONFIG_FOLDER/.uparchives.cfg $HOME/source/ExScripts/UpArchives --preserve
		cp --verbose $SAVE_CONFIG_FOLDER/.up_csv.cfg $HOME/source/ExScripts/UploadCSV --preserve



		echo -e "\n\nStep 5. Edit RMS config\n"

		# Backup RMS_config
		cp --verbose $HOME/source/RMS/.config $HOME/source/RMS/.config.bak

		# Change parameters in config
		sed -i 's\external_script_run: false\external_script_run: true\' $HOME/source/RMS/.config

		if [ "$DIST" = "$BULLSEYE" ]; then
			sed -i 's\external_script_path: /home/dvida/Desktop/rms_external.py\external_script_path: /home/rms/source/ExScripts/MainExScript.py\' $HOME/source/RMS/.config
		else
			sed -i 's\external_script_path: /home/dvida/Desktop/rms_external.py\external_script_path: /home/pi/source/ExScripts/MainExScript.py\' $HOME/source/RMS/.config
		fi

		sed -i 's\reboot_after_processing: true\reboot_after_processing: false\' $HOME/source/RMS/.config
		sed -i 's\log_dir: logs\log_dir: logs/RMS_logs\' $HOME/source/RMS/.config
		sed -i 's\live_jpg: false\live_jpg: true\' $HOME/source/RMS/.config

		echo "$HOME/source/RMS/.config configured!"



		echo -e "\n\nStep 6. Edit autostart config\n"

		case $DIST in

			"$JESSIE")
				# Backup autostart config
				sudo cp --verbose /home/pi/.config/lxsession/LXDE-pi/autostart /home/pi/.config/lxsession/LXDE-pi/autostart.bak

				string=$(( $(wc --lines /home/pi/.config/lxsession/LXDE-pi/autostart | awk '{print $1}')-7 ))
				#echo $string

				sudo sed -i $string'a\
# Starvisor\
/home/pi/source/ExScripts/Starvisor/entr_run.sh &\
' /home/pi/.config/lxsession/LXDE-pi/autostart
			;;

			"$BUSTER")
				# Backup autostart config
				sudo cp --verbose /etc/xdg/lxsession/LXDE-pi/autostart /etc/xdg/lxsession/LXDE-pi/autostart.bak

				string=$(( $(wc --lines /etc/xdg/lxsession/LXDE-pi/autostart | awk '{print $1}')-1 ))
				#echo $string

				sudo sed -i $string'a\
# Starvisor\
/home/pi/source/ExScripts/Starvisor/entr_run.sh &\
' /etc/xdg/lxsession/LXDE-pi/autostart
			;;

			"$BULLSEYE")
				# Backup autostart config
				sudo cp --verbose /etc/xdg/lxsession/LXDE-pi/autostart /etc/xdg/lxsession/LXDE-pi/autostart.bak

				string=$(( $(wc --lines /etc/xdg/lxsession/LXDE-pi/autostart | awk '{print $1}')-1 ))
				#echo $string

# sed: couldn't open temporary file /etc/xdg/lxsession/LXDE-pi/sedKhFqtn: Permission denied

				sudo sed -i $string'a\
# Starvisor\
/home/rms/source/ExScripts/Starvisor/entr_run.sh &\
' /etc/xdg/lxsession/LXDE-pi/autostart
			;;
		esac

		echo "Autostart configured!"



		echo -e "\n\nStep 7. Setting up archive downloads\n"

		# Backup list of hosts
		sudo cp --verbose /etc/hosts /etc/hosts.bak

		# Add new host
		sudo bash -c "cat >> /etc/hosts << EOF
$IP		ru000q
EOF"

		# Backup ssh config
		if [ -f $HOME/.ssh/config ]; then
			cp --verbose $HOME/.ssh/config $HOME/.ssh/config.bak
		fi

# Add ssh-alias
echo "
host SRMN
	Hostname ru000q
	User $LOGIN
	Port $PORT

" >> $HOME/.ssh/config

		# Set sshpass to auto-enter password
		sudo apt install sshpass

		# Enter password of SRMN
		sshpass -p $PASSWORD ssh-copy-id SRMN

		echo "FTP connect configured!"



		echo -e "\n\nStep 8. Edit ~/.bashrc\n"

		# Backup .bashrc
		cp --verbose $HOME/.bashrc $HOME/.bashrc.bak

		# Add aliases
		echo "

# Check RMS log
alias cklog='~/source/ExScripts/Utils/CheckLog.sh'

# Running an external script
alias exscript='~/source/ExScripts/Utils/ExScript_last_dir.sh'

# Upload archives
alias uparch='~/source/ExScripts/UpArchives/UpArchives.sh'

# Start TunnelIPCamera
alias tnlcam='~/source/ExScripts/Utils/TunnelIPCamera.sh'

# Upload CSV-files
alias upcsv='~/source/ExScripts/UploadCSV/UploadCSV.sh'
" >> $HOME/.bashrc

		echo "$HOME/.bashrc configured!"

		echo -e "\nInstallation complete! Reboot RPi..."
		sudo reboot
	;;


	'n')
		echo "Close script."
		exit 0
	;;


	*)
		echo "Input error please enter y/n or Ctr+C to EXIT! Restarting script."
		sleep 3
		clear
		$0
	;;
esac

