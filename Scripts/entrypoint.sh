#!/bin/bash

# Set admin password if provided via env var
if [ -n "$ADMIN_PASSWORD" ]; then
    echo "admin:$ADMIN_PASSWORD" | chpasswd
    echo "Info: the 'admin' password has been successfully set from the environment variable."
else
    echo "Error: no 'ADMIN_PASSWORD' environment variable set. Container will be stopped."
    sleep 5
    exit 1
fi

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf