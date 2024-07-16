#!/bin/bash

chown -R admin:admin /home/admin/Rockwell_Automation/

# Set the FT Optix Runtime as executable
RUNTIME=/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/FTOptixRuntime
if [ -f "$RUNTIME" ]; then
    chmod +x $RUNTIME
else
    echo "FT Optix Runtime does not exist, maybe it was not deployed yet."
fi

# Set the RA Ethernet IP dinary as executable
COREHOST_PATH="/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/Modules/FTOptix.RAEtherNetIP"
COREHOST_FILE="/Ubuntu_22_x64/bin/CoreServiceHost"

for dir in $COREHOST_PATH/*; do
    if [ -d "$dir" ]; then
        COREHOST="$dir$COREHOST_FILE"
        if [ -f "$COREHOST" ]; then
            chmod +x $COREHOST
            echo "FT Optix Core Service Host was properly set as executable"
        else
            echo "FT Optix Core Service Host does not exist in $dir, maybe it was not deployed yet"
        fi
    fi
done

echo "Permissions restored, sleeping to make supervisord aware of our script..."
sleep 2
