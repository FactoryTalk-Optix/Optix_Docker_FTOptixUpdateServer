#!/bin/bash
# Paths for FT Optix tools
export UPDATE_SERVER="/opt/Rockwell_Automation/FactoryTalk_Optix/ApplicationUpdateService/bin/FTOptixApplicationUpdateService"
export RUNTIME="/root/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/FTOptixRuntime"
# Check if runtime binaries are there and execute them
if [ -x "$RUNTIME" ]; then
	echo "Starting FT Optix Application..."
	chmod +x $RUNTIME
	/bin/bash -c $RUNTIME > /dev/null 2>&1 &
else
	echo "No FT Optix Application found, skipping..."
fi
# Start UpdateServer
if [ -x "$UPDATE_SERVER" ]; then
	echo "Starting FT Optix UpdateServer..."
	chmod +x $UPDATE_SERVER
	/bin/bash -c $UPDATE_SERVER
else
	echo "No FT Optix UpdateServer found! Aborting..."
fi
