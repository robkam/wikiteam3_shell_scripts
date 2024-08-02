#!/bin/bash

# Function to process <title> and <page> tags
function func_one {
    local xml_file="$1"
    filename=$(basename "$xml_file")
    echo "$filename"
    grep -E '<title(.*?)>' "$xml_file" -c
    grep -E '<page(.*?)>' "$xml_file" -c
    grep "</page>" "$xml_file" -c
}

# Function to process <revision> tags
function func_two {
    local xml_file="$1"
    grep -E '<revision(.*?)>' "$xml_file" -c
    grep "</revision>" "$xml_file" -c
}

# Function to check if the file ends with "</mediawiki>"
function check_end_tag {
    local xml_file="$1"
    if tail -n 1 "$xml_file" | grep -q "</mediawiki>"; then
        echo "File ends with </mediawiki>"
    else
        echo "File does NOT end with </mediawiki>"
    fi
    echo ""
}

# Iterate through each XML file recursively
shopt -s globstar
for xml_file in ./dumps/**/*.xml; do
    func_one "$xml_file"
    func_two "$xml_file"
    check_end_tag "$xml_file"
done
