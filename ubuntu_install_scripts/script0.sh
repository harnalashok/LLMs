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
#     script5.sh
#     script6.sh
#     script7.sh


#------ Steps ---------
#     i) Download this file in Ubuntu, and
#        execute the three commands:


#            wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script0.sh
#            perl -pi -e 's/\r\n/\n/g' ~/script0.sh
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


# Check user and hostnames
if [[ `hostname` != 'master' ]]; then
    echo "First change host name to 'master'"   | tee -a error.log
    sleep 9
    exit
fi

if [[ $USER != 'ashok' ]]; then
    echo "First change user name to 'ashok'"   | tee -a error.log
    sleep 9
    exit
fi



mkdir ~/done
echo "Downloading all script files from github" 
echo "---------------------------"
echo "  "
# Raw github files are downloaded
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script0.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script1.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script2.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script3.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script4.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/docker_install.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script5.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script7.sh -P ~/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script6.sh -P ~/next

echo "  "
echo "Script files downloaded....."
echo "Wait..You will have to supply password..."
sleep 9

# Doc to Unix conversion
perl -pi -e 's/\r\n/\n/g' ~/next/script0.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script1.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script2.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script3.sh
perl -pi -e 's/\r\n/\n/g' ~/next/docker_install.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script4.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script5.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script7.sh
perl -pi -e 's/\r\n/\n/g' ~/next/script6.sh


chmod +x *.sh
chmod +x ~/next/*.sh

# Install Anaconda
wget -c https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-2024.10-1-Linux-x86_64.sh -b
sleep 2
rm Anaconda3-2024.10-1-Linux-x86_64.sh
echo "PATH=\$PATH:~/anaconda3/bin/" >> ~/.bashrc
echo "conda init "  >> ~/info.log
echo "conda activate " >> ~/info.log
echo "conda deactivate " >> ~/info.log



# Move script file to 'done' folder
mv ~/script0.sh  ~/done
# Bring in the next file
mv ~/next/script1.sh  ~/
echo "Terminal will close."
echo "Open it again, and issue the following command"
echo "

