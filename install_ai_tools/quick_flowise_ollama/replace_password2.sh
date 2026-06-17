#!/bin/bash


# Define the target file name
TARGET_FILE="install_ubuntu.sh"


# Check if the file actually exists
if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: File '$TARGET_FILE' not found."
    exit 1
fi

# Prompt the user for the new password
echo "==========="
echo "Is your Ubuntu password different from 'ashok'?"
echo "If so, write below your password. Else, just press ENTER key."
read -p "DO NOT PUT ANY SPACES OR INVERTED COMMA before or after your password: " var

# If no password entered
if [[ -z "$var" ]]; then
    var="ashok"
    echo "Your password remains as: $var"
    exit 1
fi
# Trim leading and trailing spaces
var="${var#"${var%%[![:space:]]*}"}"
var="${var%"${var##*[![:space:]]}"}"

# Perform the in-place replacement using sed
#sed -i "s/ashok/$var/g" "$TARGET_FILE"
# Line no is 10
sed -i "10s/ashok/$var/" "$TARGET_FILE"

echo "Your password is: $var"

