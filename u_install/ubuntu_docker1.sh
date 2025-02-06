#!/bin/bash

# Last amended: 06th Feb, 2025
# Ref: https://docs.docker.com/engine/install/ubuntu/
#      https://docs.docker.com/engine/install/linux-postinstall/

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     ubuntu_docker.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7,sh
      #     script8.sh


# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check if docker installed
sudo docker run hello-world

# Run docker witout root privileges
sudo groupadd docker
sudo usermod -aG docker $USER

sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

#sudo systemctl disable docker.service
#sudo systemctl disable containerd.service
reboot
