#!/bin/bash
# update Adobe apps via default RUM tool https://helpx.adobe.com/enterprise/using/using-remote-update-manager.html
if [ ! -f "/usr/local/bin/RemoteUpdateManager" ]; then
    echo "Adobe RUM is not installed in /usr/local/bin"
    exit 1
else
    echo "Adobe RUM detected. Running update manager..."
    sudo /usr/local/bin/RemoteUpdateManager
fi
