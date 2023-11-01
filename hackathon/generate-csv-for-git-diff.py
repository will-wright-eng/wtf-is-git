import re
import csv
import sys

def main():
	files_changed = []
	final_csv = []
	commit = None
	commit_msg = None
	commit_datetime = None
	author_name = None
	author_email = None

	for line in sys.stdin:
		if all([commit, commit_msg == "\n", commit_datetime, author_name, author_email]):
			commit_msg = line.strip().strip("\n")
		if all([commit, commit_msg is None, commit_datetime, author_name, author_email]):
			commit_msg = line

		commit_match = re.match("^commit (.*)", line)
		if commit_match:
			commit = commit_match.group(1)

		author_match = re.match("Author: (.*) <(.*)>", line)
		if author_match:
			author_name = author_match.group(1)
			author_email = author_match.group(2)

		date_match = re.match("Date:   (.*)", line)
		if date_match:
			commit_datetime = date_match.group(1)

		file_change_match = re.match(r'(\d+)\s+(\d+)\s+(.*)', line)
		if file_change_match:
			added = file_change_match.group(1)
			deleted = file_change_match.group(2)
			file_changed = file_change_match.group(3)
			file_changed.append([file_changed, added, deleted])

	for file file_changed in files_changed:
		final_csv.append([commit_datettime, author_email, file_changed[0], file_changed[1], file_changed[2]])

	with open(sys.argv[1], 'a') as file:
		writer = csv.writer(file)
		for row in final_csv:
			writer.writerow(row)

if __name__ == "__main__":
	main()
