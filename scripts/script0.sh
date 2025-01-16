#!/bin/bash

# Last amended: 14th Jan, 2025

# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     model_install.sh
#     test.sh



#------ Steps ---------
#     i) Download this file in Ubuntu, and
#        execute the three commands:


#            wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script0.sh
#            perl -pi -e 's/\r\n/\n/g' /home/ashok/script0.sh
#            chmod +x *.sh

#     ii) Then, execute this file as:
#           ./script0.sh
#        OR,as
#            bash script0.sh
#     iii) This file will call script1.sh also
#          to change hostname to 'master'

#------ Steps ---------

echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: script0.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


mkdir /home/ashok/done
echo "Downloading all script files from github" 
echo "---------------------------"
echo "  "
# Raw github files are downloaded
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script0.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script1.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script2.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script3.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script4.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/docker_install.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/test.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/model_install.sh -P /home/ashok/next

echo "  "
echo "Script files downloaded....."
echo "Wait..You will have to supply password..."
sleep 9

# Doc to Unix conversion
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script0.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script1.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script2.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script3.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/docker_install.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script4.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/test.sh


chmod +x *.sh
chmod +x /home/ashok/next/*.sh

# Move script file to 'done' folder
mv /home/ashok/script0.sh /home/ashok/done
# Bring in the next file
mv /home/ashok/next/script1.sh /home/ashok

echo " Changing host name"
bash script1.sh
