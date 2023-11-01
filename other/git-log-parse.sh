#!/bin/bash

# Set the input file name
input_file="git_log.txt"

# Set the output file name
output_file="git_log.csv"

# Create the column headers in the output file
echo "changes_added, changes_deleted, file_path" > $output_file

# Read each line of the input file
while IFS=$'\t' read -r -a line; do
  # Extract the relevant information from the line
  changes_added=${line[0]}
  changes_deleted=${line[1]}
  file_path=${line[2]}

  # Append the information to the output file
  echo "$changes_added, $changes_deleted, $file_path" >> $output_file
done < $input_file

echo "CSV file created successfully."

# #!/bin/bash

# # Initialize variables
# file=""
# author=""
# date=""
# modifications=0

# # Print column headers
# echo "File,Author,Date,Modifications"

# # Read input from stdin
# while IFS=$'\t' read -r -a fields; do
#   # Skip empty lines
#   if [[ ${#fields[@]} -eq 0 ]]; then
#     continue
#   fi

#   # Extract fields
#   file="${fields[2]}"
#   author="${fields[0]}"
#   date="${fields[1]}"
#   modifications="${fields[3]}"

#   # Print row
#   echo "$file,$author,$date,$modifications"
# done