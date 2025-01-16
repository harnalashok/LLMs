#!/bin/bash

# LAst amended: 14th Jan, 2025

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     model_install.sh
#     test.sh


# Install docker engine on Ubuntu
# Better follow this reference:
# Ref:    https://docs.docker.com/engine/install/ubuntu/


# Use as: 
#   sudo bash docker_install.sh
#   OR
#   sudo ./docker_install.sh


cd ~

echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: docker_install.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log

# If not started as sudo then inform:
# ref: https://askubuntu.com/a/30157/8698
if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root. Example: sudo ./install_docker.sh" >&2
   exit 1
fi


# Who is the user?
if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi



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

echo "Downloading and installing docker engine"    | tee -a ~/error.log
echo "============"     | tee -a ~/error.log
echo " "     | tee -a ~/error.log
snap install docker
apt  install docker-compose  -y
echo " "     | tee -a ~/error.log
echo "============"     | tee -a ~/error.log
echo " "
echo "Docker engine installed."     | tee -a ~/error.log
echo "Adding user 'ashok' to 'docker' group"     | tee -a ~/error.log
echo "to enable running docker commands by 'ashok' without sudo"     | tee -a ~/error.log
sleep 9
groupadd docker
usermod -aG docker ashok
echo " "    | tee -a ~/error.log

echo "Docker installation process completed"     | tee -a ~/error.log

echo " "     | tee -a ~/error.log

echo "Machine will be rebooted in 10s"
echo "Reopen it thereafter, and perform tests"
echo "Read script4.sh for tests"
echo " "
sleep 10

# Move script file to done folder
mv ~/docker_install.sh ~/done
mv ~/next/script4.sh  ~
sleep 2
reboot
#############


#########################################
