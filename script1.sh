#!/bin/sh

# Last amended: 10th Jan, 2025
# To execute this file, you need to 
# execute the following lines in Ubuntu console
# Note the multiline bash comment here.


# Install software
echo " Updating Ubuntu"
echo "----------"
echo " "
sudo apt update
sudo apt upgrade -y
sudo apt install net-tools cmake build-essential -y  
echo " "
echo "Done ......"
sleep 4


# Change machine name
echo " "
echo "Changing machine name..."
echo "------------------"
sleep 4

echo '[boot]' | sudo tee  /etc/wsl.conf > /dev/null
echo 'systemd=true' | sudo tee -a /etc/wsl.conf > /dev/null
echo '[network]' | sudo tee -a /etc/wsl.conf > /dev/null
echo 'hostname = master' | sudo tee -a /etc/wsl.conf > /dev/null
echo 'generateHosts = false' | sudo tee -a /etc/wsl.conf > /dev/null
sudo rm /etc/resolv.conf
echo 'nameserver 8.8.8.8' | sudo tee  /etc/resolv.conf > /dev/null
sudo sed -i 's/127.0.1.1.*/127.0.1.1  master.fsm.ac.in   master/' /etc/hosts

# Install uv for langflow install
echo " "
echo "Installing uv"
echo "--------------"
echo " "
curl -LsSf https://astral.sh/uv/install.sh | sh

# Shut down ubuntu
wsl.exe --shutdown

