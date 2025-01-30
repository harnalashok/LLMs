#!/bin/bash

# Last amended: 23rd Jan, 2025

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7,sh


#------ Steps ---------
#     i) Download this file in Ubuntu, and
#        execute the three commands:


#            wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script0.sh
#            perl -pi -e 's/\r\n/\n/g' /home/ashok/script0.sh
#            chmod +x *.sh

#     ii) Then, execute this file as:
#           ./script0.sh
#        OR,as
#            bash script0.sh
#     iii) This file will call script1.sh also
#          to change hostname to 'master'

#------ Steps ---------

echo "========script0=============="
echo "Hostname is irrelevant "
echo "User name must be 'ashok'"
echo "Will check these."
echo "Will download all scripts and place them in the 'next' folder"
echo "Any scripts executed will be placed in 'done' folder"
echo "Will call script1.sh"
echo "==========================="
sleep 10

cd ~/

# Check user and hostnames
#if [[ `hostname` != 'master' ]]; then
#    echo "First change host name to 'master'"   |  tee -a /home/ashok/error.log
#    sleep 9
#    exit
#fi

if [[ $USER != 'ashok' ]]; then
    echo "First change user name to 'ashok'"   |  tee -a /home/ashok/error.log
    sleep 9
    exit
fi



echo " "                   | tee -a /home/ashok/error.log
echo "*********"           | tee -a /home/ashok/error.log
echo "Script: script0.sh"  | tee -a /home/ashok/error.log
echo "**********"          | tee -a /home/ashok/error.log
echo " "                   | tee -a /home/ashok/error.log



mkdir /home/ashok/done
echo "Downloading all script files from github" 
echo "---------------------------"
echo "  "
# Raw github files are downloaded
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script0.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script1.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script2.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script3.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script4.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/docker_install.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script5.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script6.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script7.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/download_models.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/test_llama_cpp_python.sh -P /home/ashok/next
wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/test_scripts.sh -P /home/ashok/next



echo "  "
echo "Script files downloaded....."


# Doc to Unix conversion
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script0.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script1.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script2.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script3.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/docker_install.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script4.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script5.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script6.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/script7.sh

perl -pi -e 's/\r\n/\n/g' /home/ashok/next/download_models.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/test_llama_cpp_python.sh
perl -pi -e 's/\r\n/\n/g' /home/ashok/next/test_scripts.sh

# The script gives lists of virtual venvs created
echo '#!/bin/bash'                         >   /home/ashok/find_venv.sh
echo " "                                   >>   /home/ashok/find_venv.sh
echo "cd ~/"                               >>   /home/ashok/find_venv.sh
echo "echo 'List of virtual envs:'"        >>   /home/ashok/find_venv.sh
echo "find ~ | grep -E '/bin/activate$'"   >> /home/ashok/find_venv.sh

chmod +x *.sh
chmod +x /home/ashok/next/*.sh



# Move script file to 'done' folder
mv /home/ashok/script0.sh  /home/ashok/done
# Bring in the next file
mv  /home/ashok/next/script1.sh  /home/ashok/


# Execute the bnext script
bash script1.sh


