#!/bin/bash

# Define the output CSV file
output_file="commit_history.csv"

# Initialize the CSV file with column headers
echo "Commit Author,Lines of Code Added,Lines of Code Removed,Number of Commits,First Commit Date,Last Commit Date" > "$output_file"

# Get the git commit history
git log --pretty=format:"%an,%ai" --numstat | awk '
    BEGIN {
        FS="\t";
        OFS=",";
        author="";
        added=0;
        removed=0;
        commits=0;
        first_date="";
        last_date="";
    }
    /^[0-9]+/ {
        added+=$1;
        removed+=$2;
        commits+=1;
        if (first_date == "") {
            first_date=$3;
        }
        last_date=$3;
    }
    /^Author:/ {
        author=$2;
    }
    /^$/ {
        print author, added, removed, commits, first_date, last_date;
        author="";
        added=0;
        removed=0;
        commits=0;
        first_date="";
        last_date="";
    }' >> "$output_file"

echo "Commit history has been aggregated and saved to $output_file."