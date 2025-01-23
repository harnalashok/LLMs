#!/bin/bash

# LAst amended: 14th Jan, 2025

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

# Install docker engine on Ubuntu
# Better follow this reference:
# Ref:    https://docs.docker.com/engine/install/ubuntu/


# Use as: 
#   sudo bash docker_install.sh
#   OR
#   sudo ./docker_install.sh


cd ~
echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: docker_install.sh"              | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log

# If not started as sudo then inform:
# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root. Example: sudo ./docker_install.sh" >&2
   exit 1
fi


# Who is the user?
if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi


# Does docker engine already exist?
if [[ `which docker` == "/usr/bin/docker" ]]; then
   echo "Docker appears to be already installed"
   echo "Recheck. Break this script by pressing ctrl+c"
   sleep 40
fi


# Ref: https://stackoverflow.com/a/73455413
echo "Installing docker repo and its Certificate"
cd ~
apt install ca-certificates curl gnupg lsb-release  -y
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -f -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating Ubuntu packages list.."
apt update -y
sleep 2

echo "Downloading and installing docker engine"    | tee -a /home/ashok/error.log
echo "============"                                | tee -a /home/ashok/error.log
echo " "                                           | tee -a /home/ashok/error.log
snap install docker
apt  install docker-compose  -y
echo " "                                           | tee -a /home/ashok/error.log
echo "============"                                | tee -a /home/ashok/error.log
echo " "
echo "Docker engine installed."                    | tee -a /home/ashok/error.log
echo "Adding user 'ashok' to 'docker' group"       | tee -a /home/ashok/error.log
echo "to enable running docker commands by 'ashok' without sudo"     | tee -a /home/ashok/error.log

echo "Docker engine installed."                                      | tee -a /home/ashok/info.log
echo "Added user 'ashok' to 'docker' group"                          | tee -a /home/ashok/info.log
echo "to enable running docker commands by 'ashok' without sudo"     | tee -a /home/ashok/info.log

sleep 9
groupadd docker
usermod -aG docker ashok
echo " "                                                             | tee -a /home/ashok/error.log

echo "Docker installation process completed"                         | tee -a /home/ashok/error.log

echo " "                                                             | tee -a /home/ashok/error.log

echo "Machine will be rebooted in 9s"
echo "Reopen it thereafter, and perform few tests"
echo "with script4.sh"
echo " "


# Move script file to done folder
mv /home/ashok/docker_install.sh /home/ashok/done
mv /home/ashok/next/script3.sh  /home/ashok/

echo "Close your terminal"
sleep 10



#########################################
