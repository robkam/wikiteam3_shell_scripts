#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

file="$1"

if [ ! -f "$file" ]; then
  echo "File not found!"
  exit 1
fi

filename=$(basename "$file")
filesize=$(stat -c %s "$file")
sha1hash=$(sha1sum "$file" | awk '{ print $1 }')
timestamp=$(TZ=UTC stat -c %Y "$file" | awk '{printf "%s", strftime("%FT%TZ", $1)}')
echo "Filename: $filename"
echo "Filesize: $filesize bytes"
echo "SHA1 Hash: $sha1hash"
echo "Timestamp: $timestamp"
