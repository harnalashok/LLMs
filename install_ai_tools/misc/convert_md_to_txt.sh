#!/bin/bash

echo "   "
echo "============"
echo "First cd to folder that contains md files"
echo "If not, ctrl+c first, and then run this script"
echo "You have 10secs"
echo "=============="
echo "    "
sleep 10
for f in *.md; do
  pandoc "$f" -t plain -o "${f%.md}.txt"
done
echo "Done.....You cancheck..."
