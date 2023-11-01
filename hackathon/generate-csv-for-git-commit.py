import re
import csv
import sys

def parse_hunk_header(header):
	header = re.match("\-.* \+(.*)", header).group(1)
	past_comma = False
	inital_line = ""
	line_range = ""

	for char in header:
		if char == ",":
			past_comma = True
			continue
		if past_comma:
			line_range += char
		else:
			initial_line += char
	if line_range == "":
		line_range = 0
		return (int(initial_line), int(initial_line) + int(line_range))

final_csv = []
filename = None
line_range = None
try:
	for line in sys.stdin:
		file_match = re.match("\+\+\+ b/(.*)", line)
		if file_match:
			filename = file_match.group(1)

		hunk_match = re.match("@@ (.*) @@", line)
		if hunk_match:
			line_range = parse_hunk_header(hunk_match.group(1))

		if filename and line_range:
			final_csv.append([sys.argv[1], filename, line_range[0], line_range[1]])
			filename = None
			line_range = None

	with open(sys.argv[2], 'a') as file:
		writer = csv.writer(file)
		for row in final_csv:
			writer.writerow(row)

except UnicodeDecodeError as e:
	print("UnicodeDecodeError")
	print(e)
