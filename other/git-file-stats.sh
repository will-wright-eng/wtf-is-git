#!/bin/bash

# Create a temporary file
temp_file=$(mktemp)
filename=output.csv
rm "$filename"

# Crawl the current directory excluding .git directory
repo_root="$(git rev-parse --show-toplevel)"
find "$repo_root" -type f -not -path '*/.git/*' | while read -r file
do
    # Get the file extension
    extension="${file##*.}"
    # Count the lines in the file
    echo $file
    lines=$(wc -l < "$file")
    # Output the extension and lines to the temporary file
    echo "$extension,$lines" >> "$temp_file"
done

echo "extension,count,lines" >> "$filename"
# Process the temporary file to get the final counts
awk -F, '{ext[$1]++; lines[$1]+=$2} END{for (i in ext) print i, ext[i], lines[i]}' OFS=, "$temp_file" >> "$filename"

# Remove the temporary file
rm "$temp_file"