#!/bin/bash

# Remote server details
REMOTE_USER="sdr"
REMOTE_HOST="dev-wks"
REMOTE_PATH="/home/sdr/workspace/puch-workspace/Add_DMA_Capture_Buffer_QPSK"

# Local mount point
LOCAL_MOUNT_POINT="/root/jupyter_notebooks/puch"

# Check if the mount point exists, create if not
if [ ! -d "$LOCAL_MOUNT_POINT" ]; then
    mkdir -p "$LOCAL_MOUNT_POINT"
fi

# Mount the remote directory
sshfs -o allow_other,default_permissions "$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_PATH" "$LOCAL_MOUNT_POINT"

# Check if the mount was successful
if [ $? -eq 0 ]; then
    echo "SSHFS mount successful: $REMOTE_HOST:$REMOTE_PATH mounted to $LOCAL_MOUNT_POINT"
else
    echo "SSHFS mount failed."
fi
