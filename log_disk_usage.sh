#!/bin/bash

# Log file
LOG_FILE="/var/log/disk_usage/disk_usage.log"

# Get the current date and disk usage
DATE=$(date +"%Y-%m-%d %H:%M:%S")
USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')

# Write to the log file
echo "$DATE $USAGE" >> $LOG_FILE
