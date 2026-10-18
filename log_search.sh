#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <log_file> <keyword>"
    exit 1
fi

LOG_FILE=$1
KEYWORD=$2
RESULT_FILE="${KEYWORD}_$(basename "$LOG_FILE")"

if [ ! -f "$LOG_FILE" ]; then
    echo "File $LOG_FILE not found"
    exit 1
fi

grep "$KEYWORD" "$LOG_FILE" > "$RESULT_FILE"
COUNT=$(wc -l < "$RESULT_FILE")

echo "Found $COUNT lines with $KEYWORD"
echo "Saved to $RESULT_FILE"
