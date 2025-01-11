#!/bin/sh

# Last amended: 11th Jan, 2025


echo "Downloading files from Internet

wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script1.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script2.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script3.sh
echo "Done....."
sleep 2

perl -pi -e 's/\r\n/\n/g' script1.sh
perl -pi -e 's/\r\n/\n/g' script2.sh
perl -pi -e 's/\r\n/\n/g' script3.sh

chmod +x *.sh

echo " Changing host name"
bash script1.sh
