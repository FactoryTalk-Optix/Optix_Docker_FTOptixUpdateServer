#!/bin/bash

chown -R admin:admin /home/admin/Rockwell_Automation/

RUNTIME=/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/FTOptixRuntime
if [ -f "$RUNTIME" ]; then
    chmod +x $RUNTIME
else
    echo "FT Optix Runtime does not exist, maybe it was not deployed yet."
fi

echo "Permissions restored, sleeping to make supervisord aware of our script..."
sleep 2
