#!/bin/sh

# Last amended: 10th Jan, 2025
# To execute this file, you need to 
# execute the following lines in Ubuntu console
# Note the multiline bash comment here.
: '
cp  /mnt/c/users/ashok/Downloads/script1.sh ~/
cp  /mnt/c/users/ashok/Downloads/script2.sh ~/
#cp  /mnt/c/users/ubuntu/Downloads/script1.sh ~/
perl -pi -e 's/\r\n/\n/g' script1.sh
perl -pi -e 's/\r\n/\n/g' script2.sh
chmod +x *.sh
bash script1.sh
'


# Install software
sudo apt update
sudo apt upgrade -y
sudo apt install net-tools cmake build-essential -y 

# Install uv for langflow install
echo "Installing uv"
curl -LsSf https://astral.sh/uv/install.sh | sh


# Change machine name
echo "Changing machine name..."
echo '[boot]' | sudo tee  /etc/wsl.conf > /dev/null
echo 'systemd=true' | sudo tee -a /etc/wsl.conf > /dev/null
echo '[network]' | sudo tee -a /etc/wsl.conf > /dev/null
echo 'hostname = master' | sudo tee -a /etc/wsl.conf > /dev/null
echo 'generateHosts = false' | sudo tee -a /etc/wsl.conf > /dev/null
sudo rm /etc/resolv.conf
echo 'nameserver 8.8.8.8' | sudo tee  /etc/resolv.conf > /dev/null
sudo sed -i 's/127.0.1.1.*/127.0.1.1  master.fsm.ac.in   master/' /etc/hosts

# Shut down ubuntu
wsl.exe --shutdown
