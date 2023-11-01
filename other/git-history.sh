#!/bin/bash

# Create a temporary file
temp_file=$(mktemp)

# Get commit history from git
git log --pretty=format:'%an' --shortstat | awk 'BEGIN{print "Author,Added,Removed,Commits,First Commit,Last Commit"} \
    /./{if ($0 ~ /^[0-9]/) {added+=$4; removed+=$6; commits++} else {if (commits > 0) {print author","added","removed","commits","first_commit","last_commit}; author=$0; added=0; removed=0; commits=0; last_commit=first_commit; first_commit=strftime("%Y-%m-%d")}} \
    END{print author","added","removed","commits","first_commit","last_commit}' > "$temp_file"

# Move the temporary file to the final CSV file
mv "$temp_file" git_history.csv