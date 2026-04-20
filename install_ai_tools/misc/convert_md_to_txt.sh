#!/bin/bash

echo "   "
echo "============"
echo "Convert markdown files (.md) to text files"
echo "But first cd to folder that contains .md files"
echo "Else, ctrl+c first, and then run this script"
echo "You have 10secs"
echo "=============="
echo "    "
sleep 10
for f in *.md; do
  pandoc "$f" -t plain -o "${f%.md}.txt"
done
echo "Done.....You cancheck..."
