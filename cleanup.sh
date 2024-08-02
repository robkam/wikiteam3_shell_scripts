#!/bin/bash

# Directory containing the dumps
DUMPS_DIR="./dumps"

# Target directory for the .7z files on Windows
TARGET_DIR="/mnt/c/Users/USER/PATH/"

# Compress each subfolder in ./dumps into a .7z file, excluding unwanted file types
find "$DUMPS_DIR" -mindepth 1 -maxdepth 1 -type d -exec bash -c '
    for dir; do
        base=$(basename "$dir")
        cd "$dir" || exit 1
        7z a "../${base}.7z" -x!*.7z -x!*.log -x!*.zst -x!*.mark *
        cd - >/dev/null || exit 1
    done
' bash {} +

# Move *.7z archives to the specified Windows folder
mv "$DUMPS_DIR"/*.7z "$TARGET_DIR"

# Recursively delete every folder and its contents below ./dumps
echo "Deleting all directories and their contents under $DUMPS_DIR..."
find "$DUMPS_DIR" -mindepth 1 -type d -exec rm -rf {} +

# Delete every file in dumps except *.txt files
echo "Deleting all files in $DUMPS_DIR except *.txt files..."
find "$DUMPS_DIR" -maxdepth 1 -type f ! -name '*.txt' -exec rm -f {} +
