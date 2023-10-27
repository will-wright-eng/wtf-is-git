#!/bin/bash

# Create a temporary file
temp_file=$(mktemp)

# Crawl the current directory excluding .git directory
find . -type f -not -path './.git/*' | while read -r file
do
    # Get the file extension
    extension="${file##*.}"
    # Count the lines in the file
    lines=$(wc -l < "$file")
    # Output the extension and lines to the temporary file
    echo "$extension,$lines" >> "$temp_file"
done

# Process the temporary file to get the final counts
awk -F, '{ext[$1]++; lines[$1]+=$2} END{for (i in ext) print i, ext[i], lines[i]}' OFS=, "$temp_file" > output.csv

# Remove the temporary file
rm "$temp_file"