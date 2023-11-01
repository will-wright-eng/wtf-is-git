#!/bin/bash

trim() {
	local var="$1"
	var="${var#"${var%%[![:space:]]*}"}"
	var="${var%"${var##*[![:space:]]}"}"
	echo -n "$var"
}

temp_file="$(mktemp)"

git shortlog -se > "$temp_file"

# reset results file
res_file=authors.txt
rm "$res_file"
touch "$res_file"
first_flag=0

while read line; do
	fields=($line)
	num_fields="${#fields[@]}"

	for (( i=0; i<$num_fields; i++ )); do
		if [[ $i -eq 0 ]]; then
			if [[ $first_flag -eq 0 ]]; then
				first_flag=1
			else
				echo "$(trim "$line_author")" >> "$res_file"
				line_author=""
			fi
		else
			line_author+="${fields[i]} "
		fi
	done

done

rm "$temp_file"
cat "$res_file"
