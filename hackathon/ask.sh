#!/bin/bash

set -euo pipefail
exec 1>&1

prompt="$1"
filepath="$2"
repo_path="$3"

logfile="$repo_path/log.txt"
echo '## Prompt\n\n' >> "$logfile"
echo "$prompt" >> "$logfile"

echo '\n\n## Response\n' >> "$logfile"
head -n 400 "$filepath" | \
	vgpt "$prompt" --temperature=0.2 | \
	tee -a "$logfile"
