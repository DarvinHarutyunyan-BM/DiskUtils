#!/bin/bash

# Array of mount points
DISKS=("/" "/mnt/disk1" "/mnt/disk2" "/mnt/disk3")

# Get the current date
DATE=$(date +"%Y-%m-%d %H:%M:%S")

for DISK in "${DISKS[@]}"; do
    # Log file for the current disk
    LOG_FILE="/var/log/disk_usage/$(basename $DISK).log"

    # Get the current disk usage
    USAGE=$(df $DISK | grep -v Filesystem | awk '{ print $5 }' | sed 's/%//g')

    # Write to the log file
    echo "$DATE $USAGE" >> $LOG_FILE
done
