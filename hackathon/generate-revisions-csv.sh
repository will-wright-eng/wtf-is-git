#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

src_dir=$(pwd)

cd "$1"

revlist=$(git rev-list --all)
commit_history_breakpoint=$(date -v 6m "+%s")

echo "COMMIT_DATETIME,AUTHOR_EMAIL,FILE_CHANGED,ADDED_LINES,DELETED_LINES" > "$2"

while read -r rev; do
	git show --numstat "$rev" | python3 "$src_dir/generate_csv_for_git_commit.py" "$2"
	last_commit_date=$(tail -1 "$2" | cut -d',' -f1)
	last_commit_date_converted=$(date -j -f "%a %b %d %H:%M:%S %Y %z" "$last_commit_date" "+%s")
	if [[ "$commit_history_breakpoint" -ge "$last_commit_date_converted" ]]; then
		break
	fi
done <<<"$revlist"

cp "$2" "$src_dir"
rm -rf "$2"