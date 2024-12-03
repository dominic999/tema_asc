#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Get the filename from the argument
file="$1"

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "File not found!"
  exit 1
fi

# Create a temporary file to store the modified content
temp_file=$(mktemp)

# Loop through each line in the file
while IFS= read -r line; do
  # Check if the line starts with 1, 2, or 3 digits
  if [[ "$line" =~ ^[0-9]{1,3} ]]; then
    # Remove the first 1, 2, or 3 digits if they are numbers
    line="${line#[0-9][0-9][0-9]}"  # Remove first 3 digits
    line="${line#[0-9][0-9]}"        # Remove first 2 digits (if needed)
    line="${line#[0-9]}"              # Remove first 1 digit (if needed)
  fi
  # Write the modified line to the temp file
  echo "$line" >> "$temp_file"
done < "$file"

# Move the temp file back to the original file
mv "$temp_file" "$file"

echo "File has been updated."

