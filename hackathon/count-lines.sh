#!/bin/bash

root_dir=$(git rev-parse --show-toplevel)
tmp_file=$(mktemp)

git -C "$root_dir" ls-files | while read -r file
do
	extension="${file##*.}"
	line_count=$(wc -l < "$rootdir/$file")
	echo "$extension $line_count" >> "$tmp_file"
done

awk '{lines[$1] += $2} END {for (extension in lines) print extension ": " lines[extension] " lines"}' "$tmp_file"
rm "$tmp_file"
