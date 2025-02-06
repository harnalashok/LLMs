#!/bin/bash

# Last amended: 06th Feb, 2025
# Ref: https://docs.docker.com/engine/install/ubuntu/
#      https://docs.docker.com/engine/install/linux-postinstall/

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     ubuntu_docker1.sh
      #     ubuntu_docker2.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7,sh
      #     script8.sh

# Check if docker installed
sudo docker run hello-world

# Run docker witout root privileges
sudo groupadd docker
sudo usermod -aG docker $USER

sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

sudo systemctl disable docker.service
sudo systemctl disable containerd.service

# Move script file to done folder
mv /home/ashok/ubuntu_docker2.sh       /home/ashok/done
mv /home/ashok/next/script3.sh  /home/ashok/

echo "Machine will be rebooted "
echo "After restart, execute:"
echo "    ./script3.sh"
sleep 10
reboot

