#!/bin/sh

# Last amended: 10th Jan, 2025
# This file is called by script0.sh


# Install software
echo "  "
echo "------------"
echo " Will update Ubuntu"
echo " You will be asked for password...supply it..."
echo "----------"
echo " "
sleep 9
sudo apt update
sudo apt upgrade -y
sudo apt install zip unzip net-tools cmake  build-essential -y  

echo " "
echo "Done ......"

# Install 'fnm' (Fast Node Manager)
echo " "
echo "Will install fnm: Fast Node Manager..."
echo "------------------"
sleep 9
sudo curl -fsSL https://fnm.vercel.app/install | bash

# Change machine name
echo " "
echo "Will change machine name..."
echo "------------------"
sleep 9

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
sleep 5
curl -LsSf https://astral.sh/uv/install.sh | sh

# Shut down ubuntu
echo " "
echo "*******"
echo "Ubuntu terminal will be closed."
echo "Reopen it after it closes, and then execute the command:"
echo "     ./script2.sh"
echo "*******"
echo " "
sleep 9
wsl.exe --shutdown

