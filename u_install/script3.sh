#!/bin/bash

# LAst amended: 14th Jan, 2024

# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     docker_install.sh
#     script3.sh
#     script4.sh
#     script5.sh
#     script6.sh
#     script7.sh
#     script8.sh

cd ~/


echo "========script3=============="
echo "Will install Flowise using npm (node package manager)"
echo "Reboot and call script4.sh"
echo "==========================="
sleep 10


echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script3.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log


# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."                  | tee -a /home/ashok/error.log
echo "------"                                               | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
sleep 2

npm install -g flowise  2>> /home/ashok/error.log
echo " "
echo " "                                                    | tee -a /home/ashok/error.log
echo "flowise installed"                                    | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
echo "flowise installed"                                    | tee -a /home/ashok/info.log
echo "flowise port is: 3000"                                | tee -a /home/ashok/info.log
echo " "                                                    | tee -a /home/ashok/info.log


echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_npx_flowise.sh  
echo " "                                                   | tee -a /home/ashok/start/start_npx_flowise.sh
echo "cd ~/"                                               | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Flowise will be available at port 3000'"       | tee -a /home/ashok/start/start_npx_flowise.sh
echo "npx flowise start"                                   | tee -a /home/ashok/start/start_npx_flowise.sh
echo "netstat -aunt | grep 3000"                           | tee -a /home/ashok/start/start_npx_flowise.sh

chmod +x /home/ashok/start/*.sh

sleep 2


# Move script file to done folder
mv /home/ashok/script3.sh  /home/ashok/done
mv /home/ashok/next/script4.sh  /home/ashok/

#bash script4.sh
reboot
echo " "
echo "Shut down Ubuntu console"
echo "Reopen it and install  as:"
echo "  ./script4.sh"
echo "----------"
echo " "
exec sleep 10
exit


