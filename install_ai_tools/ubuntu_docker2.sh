#!/bin/bash

# Last amended: 15th April, 2025
# Ref: https://docs.docker.com/engine/install/ubuntu/
#      https://docs.docker.com/engine/install/linux-postinstall/


echo " "
echo "=========="
echo "'ubuntu_docker1.sh' must have been executed earlier to this script. Else, this script will give errors."
echo "Break by pressing ctrl+c if 'ubuntu_docker1.sh' not executed"
echo "============"
echo " "
sleep 10
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


# PReparing docker for GPU
# Ref StackOverflow: https://stackoverflow.com/a/77269071
# Ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installation

# 1.0 Configure the repository (it is one command):
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey |sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
&& curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
&& sudo apt-get update

# 2.0 Install the NVIDIA Container Toolkit packages:

sudo apt-get install -y nvidia-container-toolkit

# 3.0  Configure the container runtime by using the nvidia-ctk command:

sudo nvidia-ctk runtime configure --runtime=docker

# 4.0 Restart the Docker daemon:

sudo systemctl restart docker

# Store docker help files
mkdir /home/ashok/Documents/dockers
cd /home/ashok/Documents/dockers
wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/Understanding%20docker%20technology.pdf?raw=true
wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/docker%20commands.txt?raw=true
wget -c https://github.com/harnalashok/LLMs/blob/main/install_ai_tools/docker/dockers%20in%20brief.pdf?raw=true
cd /home/ashok/

echo "Machine will be rebooted "
#echo "After restart, execute:"
#echo "    ./script3.sh"
#sleep 10
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    wsl.exe --shutdown
else
    reboot
fi  


