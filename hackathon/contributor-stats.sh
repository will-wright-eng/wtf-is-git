#!/bin/bash

filename=contributor-stats.csv
author_results=authors.txt
rm "$filename"
touch "$filename"

get_contrib_stats() {
	contributor="$1"
	added_lines=0
	deleted_lines=0
	first_date=""
	last_date=""

	while read -r line; do
		if [[ $line =~ ([0-9]+)\ file.*([0-9]+)\ insertions.*([0-9]+)\ deletions.* ]]; then
			added_lines=$((added_lines + ${BASH_REMATCH[2]}))
			deleted_lines=$((deleted_lines + ${BASH_REMATCH[3]}))
		elif [[ $line =~ Date:\ +(.*) ]]; then
			if [ -z "$first_date" ]; then
				first_date="${BASH_REMATCH[1]}"
			fi
			last_date="${BASH_REMATCH[1]}"
		fi
	done < <(git log --author="$contributor" --format"Date: %ad%n%aN" --shortstat)
	# done < <(git log --author="$contributor" --format"Date: %aD%n%aN" --shortstat)

	echo "$contributor, $added_lines, $deleted_lines, $first_date, $last_date" >> "$filename"
}

echo "AUTHOR,TOTAL_ADDED_LINES,TOTAL_DELETED_LINES,FIRST_COMMIT_DATE,LAST_COMMIT_DATE" >> "$filename"
while read -r line; do
	echo "$line"
	get_contrib_stats "$line"
done < "$author_results"
