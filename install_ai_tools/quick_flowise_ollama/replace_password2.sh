#!/bin/bash


# Define the target file name
TARGET_FILE="install_ubuntu.sh"

# Check if the file actually exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: File '$TARGET_FILE' not found."
    exit 1
fi

# Prompt the user for the new password
read -p "Enter your password to replace 'ashok': " var


# Trim leading and trailing spaces
var="${var#"${var%%[![:space:]]*}"}"
var="${var%"${var##*[![:space:]]}"}"

# Perform the in-place replacement using sed
sed -i "s/ashok/$var/g" "$TARGET_FILE"

echo "Password replaced!"
