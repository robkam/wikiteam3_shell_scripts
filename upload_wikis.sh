#!/bin/bash

# Path to the dumps folder
DUMPS_FOLDER="./dumps"

# Path to the keys file
KEYS_FILE="../.wikiteam3_ia_keys.txt"

# Function to handle uploading and logging
upload_and_log() {
    local WIKIDUMP_DIR="$1"
    local LOG_FILE="${WIKIDUMP_DIR%/}.log"  # Create a log file named after the subfolder

    echo "Uploading $WIKIDUMP_DIR ..."
    echo "Uploading $WIKIDUMP_DIR ..." > "$LOG_FILE"

    # Start time
    start_time=$(date +%s)

    # Run the uploader command, capturing stdout and stderr to both screen and log file
    wikiteam3uploader -kf "$KEYS_FILE" -c opensource "$WIKIDUMP_DIR" >> "$LOG_FILE" 2>&1

    # End time
    end_time=$(date +%s)

    # Calculate duration in seconds
    duration=$((end_time - start_time))

    # Calculate hours, minutes, and seconds
    hours=$((duration / 3600))
    minutes=$(( (duration % 3600) / 60 ))
    seconds=$((duration % 60))

    # Format the duration
    duration_formatted=$(printf "%02d:%02d:%02d" "$hours" "$minutes" "$seconds")

    # Append duration line to the log file
    echo "Upload duration: $duration_formatted" >> "$LOG_FILE"

    echo "Upload of $WIKIDUMP_DIR complete. Duration: $duration_formatted"
}

# Iterate over each subfolder in the dumps folder
for WIKIDUMP_DIR in "$DUMPS_FOLDER"/*/; do
    upload_and_log "$WIKIDUMP_DIR"
done
