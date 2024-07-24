#!/bin/bash

# Log file
LOG_FILE="/var/log/disk_usage/disk_usage.log"
THRESHOLD=100
DAYS_AHEAD=10
EMAIL="your_email@example.com"

# Check if the log file exists
if [ ! -f $LOG_FILE ]; then
    echo "Log file not found!"
    exit 1
fi

# Calculate the average daily growth
PREV_USAGE=0
GROWTH_SUM=0
GROWTH_COUNT=0
PREV_DATE=""

while read -r LINE; do
    CUR_DATE=$(echo $LINE | awk '{print $1" "$2}')
    CUR_USAGE=$(echo $LINE | awk '{print $3}')

    if [ -n "$PREV_DATE" ]; then
        DIFF_DAYS=$(( ($(date -d "$CUR_DATE" +%s) - $(date -d "$PREV_DATE" +%s)) / 86400 ))
        if [ $DIFF_DAYS -gt 0 ]; then
            GROWTH=$(( ($CUR_USAGE - $PREV_USAGE) / $DIFF_DAYS ))
            GROWTH_SUM=$(( $GROWTH_SUM + $GROWTH ))
            GROWTH_COUNT=$(( $GROWTH_COUNT + 1 ))
        fi
    fi

    PREV_DATE=$CUR_DATE
    PREV_USAGE=$CUR_USAGE
done < $LOG_FILE

# Calculate average daily growth
if [ $GROWTH_COUNT -gt 0 ]; then
    AVG_GROWTH=$(( $GROWTH_SUM / $GROWTH_COUNT ))
else
    AVG_GROWTH=0
fi

# Predict future usage
if [ $AVG_GROWTH -gt 0 ]; then
    PREDICTED_USAGE=$(( $CUR_USAGE + $AVG_GROWTH * $DAYS_AHEAD ))
else
    PREDICTED_USAGE=$CUR_USAGE
fi

# Check if predicted usage exceeds threshold
if [ $PREDICTED_USAGE -gt $THRESHOLD ]; then
    echo "Disk usage is predicted to exceed ${THRESHOLD}% within ${DAYS_AHEAD} days. Current usage: ${CUR_USAGE}%. Predicted usage: ${PREDICTED_USAGE}%." | mail -s "Disk Usage Alert" $EMAIL
fi
