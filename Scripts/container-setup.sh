#!/bin/bash
TARGETPLATFORM=$(uname -m)
echo "------------------------------------"
echo "--- Building for $TARGETPLATFORM ---"
echo "------------------------------------"
echo "Preparing UpdateService requirements..."
if [[ $TARGETPLATFORM =~ "x86_64" ]]; then
	# Launch UpdateService installer
	script_path=$(find FTOptixApplicationUpdateService.Ubuntu*)
	echo "Install script: " $script_path
	# UpdateServer file not found
	if [ -z "$script_path" ]; then
		echo "FTOptixApplicationUpdateService*.sh install file not found. Aborting!"
		exit 1
	fi
	# Preparing input UpdateServer file
	sed -i 's/read/#read/g' $script_path
	sed -i 's/bold/#bold/g' $script_path
	sed -i 's/normal/#normal/g' $script_path
	sed -i 's/exit/#exit/g' $script_path
	sed -i 's/$install_path\/install.sh/exit 0/g' $script_path
	# Install UpdateServer
	echo "Installing UpdateServer..."
	./$script_path
	# Check install result
	exit_status=$?
	if [ $exit_status -eq 0 ]; then
		echo "UpdateServer installation completed."
	else
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!UpdateServer installation failed!"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit $exit_status
	fi
	# Decompress LicenseManager
	echo "License manager must be manually configured! Application will run in demo mode!"
	echo "Completing..."
	mkdir -p ~/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication
else
	echo "This system architecture is not supported! Exiting..."
	exit 1
fi
# Check install result
exit_status=$?
if [ $exit_status -eq 0 ]; then
	echo "Container building for $TARGETPLATFORM done!"
else
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!Dependencies installation failed!"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit $exit_status
fi
# Cleaning up files
shopt -s extglob
shopt -u extglob
# Completing steps
echo "Please wait for Docker to finish cleaning..."