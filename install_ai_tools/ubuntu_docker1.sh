#!/bin/bash

# Last amended: 06th Feb, 2025
# Ref: https://docs.docker.com/engine/install/ubuntu/
#      https://docs.docker.com/engine/install/linux-postinstall/

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
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin  -y


# Move script file to done folder
mv /home/ashok/ubuntu_docker1.sh       /home/ashok/done
mv /home/ashok/next/ubuntu_docker2.sh  /home/ashok/

echo "Ubuntu will be closed/rebooted "
echo "After opening/restart, execute:"
echo "    ./ubuntu_docker2.sh"
sleep 10
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    wsl.exe --shutdown
else
    reboot
fi    


