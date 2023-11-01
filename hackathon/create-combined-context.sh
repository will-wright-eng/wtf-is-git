#!/bin/bash

filename=combined-csvs.txt
echo "" > "$filename"

add_data() {
	local datafile="$1"
	local datafile_title="$2"
	echo "'$datafile_title'" >> "$filename"
	echo "---" >> "$filename"
	cat "$datafile" >> "$filename"
	echo "---" >> "$filename"
}

datafile=author_stats.csv
datafile_title="author stats table"
add_data "$datafile" "$datafile_title"

datafile=code_stats.csv
datafile_title="code stats table"
add_data "$datafile" "$datafile_title"

datafile=commit_history.csv
datafile_title="commit history table"
add_data "$datafile" "$datafile_title"
