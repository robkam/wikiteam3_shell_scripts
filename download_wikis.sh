#!/bin/bash

# Define the base dump generator command
#BASE_DUMP_COMMAND="wikiteam3dumpgenerator --xml --xmlrevisions --force --delay 0 --images --bypass-cdn-image-compression"
#BASE_DUMP_COMMAND="wikiteam3dumpgenerator --xml --xmlrevisions --force --delay 0 --images"
BASE_DUMP_COMMAND="wikiteam3dumpgenerator --xml --xmlrevisions --force --delay 0"

# Define the additional command for login-required scenarios
DUMP_COMMAND_PLUS="--cookies cookies.txt --user USER --pass PASSWORD"


# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <urls_file>"
    exit 1
fi

# Ensure the script runs in the ./dumps folder
if ! cd dumps; then
    echo "Error: 'dumps' directory does not exist."
    exit 1
fi

# Counter to track dump numbers per domain
declare -A domain_counters

# Read each line from the provided file
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^\s*# ]]; then
        continue
    fi

    # Extract the URL and token from the line
    url=$(echo "$line" | awk '{print $1}')
    token=$(echo "$line" | awk '{print $2}')

    # Determine if login is needed based on token presence
    if [[ -n "$token" && "$token" == "login_required" ]]; then
        DUMP_COMMAND="$BASE_DUMP_COMMAND $DUMP_COMMAND_PLUS"
    else
        DUMP_COMMAND="$BASE_DUMP_COMMAND"
    fi

    # Extract domain name and remove "https://"
    domain=$(echo "$url" | awk -F/ '{print $3}')

    # Increment counter for the domain
    (( domain_counters[$domain]++ ))

    # Generate the log file name
    logfile="${domain}_$(printf "%03d" ${domain_counters[$domain]}).log"

    # Start time
    start_time=$(date +%s)

    # Run the dump generator command and capture only its output
    if ! { $DUMP_COMMAND "$url"; } > >(tee -a "$logfile") 2> >(grep -vE '^real |^user |^sys ' >> "$logfile"); then
        echo "Error: Failed to run dump for $url" >> "$logfile"
        echo "Dump for $url failed. Check $logfile for details."
        continue
    fi

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
    echo "Dump duration: $duration_formatted" >> "$logfile"

    # Notify the user
    echo "Dump for $url completed and saved to $logfile"
done < "$1"