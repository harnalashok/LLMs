#!/bin/sh

# Last amended: 11th Jan, 2025
# Connected scripts are:
# script0.sh, script1.sh, script2.sh, script3.sh, script4.sh
# These sscripts run in sequence.

#------ Steps ---------
#     i) Download this file in Ubuntu, and
#        execute the three commands:

#            wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script0.sh
#            perl -pi -e 's/\r\n/\n/g' script0.sh
#            chmod +x *.sh

#     ii) Then, execute this file as:
#           ./script0.sh
#        OR,as
#            bash script0.sh
#     iii) This file will call script1.sh also
#          to change hostname to 'master'

#------ Steps ---------


echo "Downloading script files from Internet
echo "---------------------------"
echo " 
# Raw github files are downloaded
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script0.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script1.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script2.sh
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/script3.sh
https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/docker_install.sh
echo "  "
echo "Done....."
sleep 4

# Doc to Unix conversion
perl -pi -e 's/\r\n/\n/g' script0.sh
perl -pi -e 's/\r\n/\n/g' script1.sh
perl -pi -e 's/\r\n/\n/g' script2.sh
perl -pi -e 's/\r\n/\n/g' script3.sh
perl -pi -e 's/\r\n/\n/g' docker_install.sh

chmod +x *.sh

echo " Changing host name"
bash script1.sh
