#!/bin/bash

# Install docker engine on Ubuntu
# Ref: https://docs.docker.com/engine/install/ubuntu/

# LAst amended: 22nd Nov, 2024
# Use as: 
#   sudo bash install_docker.sh
#   OR
#   sudo ./install_docker.sh


cd ~

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

# Ref: https://stackoverflow.com/a/73455413
echo "Installing docker repo and its Certificate"
cd ~
apt install -y ca-certificates curl gnupg lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating Ubuntu packages list.."
apt update -y
sleep 2

echo "Downloading and installing docker engine"
echo "============"
echo " "
snap install docker
apt  install docker-compose  -y
echo " "
echo "============"
echo " "
echo "Docker engine installed."
echo "Adding user 'ashok' to 'docker' group"
echo "to enable running docker commands by 'ashok' without sudo"
sleep 4
groupadd docker
usermod -aG docker ashok
echo " "

echo " "
echo "Done.... "
echo "Machine will be rebooted in 10s"
echo " "
sleep 10
reboot
#############


#########################################
