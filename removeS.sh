#!/bin/bash

# Check if the correct number of arguments is passed
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Get the file name from the argument
file=$1

# Check if the file exists
if [ ! -f "$file" ]; then
  echo "File '$file' does not exist."
  exit 1
fi

# Use sed to delete the first 1 or 2 spaces from each line
sed -i 's/^[[:space:]]\{1,2\}//' "$file"

echo "First 1 or 2 spaces removed from each line in '$file'."

