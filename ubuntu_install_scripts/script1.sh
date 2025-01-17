#!/bin/bash

# Last amended: 14th Jan, 2025



# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     model_install.sh
#     test.sh
#     last.sh


# This file is called by script0.sh


echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: script1.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log


# Install software
echo "  "
echo "------------"   | tee -a error.log
echo " Will update Ubuntu"  | tee -a error.log
echo " You will be asked for password...supply it..."
echo "----------"   | tee -a error.log
echo " "
sleep 2
sudo apt update
sudo apt upgrade -y
sudo apt install zip unzip net-tools cmake  build-essential python3-pip tilde curl git -y  

echo " "
echo "Ubuntu upgraded ......"  | tee -a error.log

# Install 'fnm' (Fast Node Manager)
echo " "   | tee -a error.log
echo "Will install fnm: Fast Node Manager..."  | tee -a error.log
echo "------------------"   | tee -a error.log
sleep 9
sudo curl -fsSL https://fnm.vercel.app/install | bash   2>> error.log

# Install chromadb
echo " "   | tee -a error.log
echo " Will Install chromadb"  | tee -a error.log
echo "------------"   | tee -a error.log
echo " "   | tee -a error.log
sleep 9
pip install chromadb   2>> error.log

sleep 2
echo " "    | tee -a error.log
echo "ChromaDB installed"    | tee -a error.log
echo "Installation is at: ~/.local/bin/chroma"  | tee -a error.log
eecho "------ "    | tee -a error.log

#  TO START CHROMA AS a SERVICE
#*********************************
echo '[Unit]'  > chroma.service
echo "Description = Chroma Service" >> chroma.service
echo "After = network.target"  >> chroma.service
echo " " >>  chroma.service
echo "[Service]"  >> chroma.service
echo "Type = simple"  >> chroma.service
echo "User = root"  >> chroma.service
echo "Group = root"  >> chroma.service
echo "WorkingDirectory = ~/Documents"  >> chroma.service
echo "ExecStart=~/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path ~/Documents/data --log-path /var/log/chroma.log"  >> chroma.service
echo " "  >> chroma.service
echo "[Install]"  >> chroma.service
echo "WantedBy = multi-user.target"  >> chroma.service
sudo mv chroma.service /etc/systemd/system/chroma.service
#---------------------

# You can now start chroma, as:
echo " "     | tee -a error.log
echo "---Start/Stop Chroma as-------"     | tee -a error.log
echo "sudo systemctl daemon-reload"   | tee -a error.log
echo "sudo systemctl enable chroma"     | tee -a error.log
echo "sudo systemctl start chroma"     | tee -a error.log
echo "Chroma is available at port 8000"     | tee -a error.log
echo "Check as: "      | tee -a error.log
echo "    netstat -aunt | grep 8000"      | tee -a error.log
echo "----------"      | tee -a error.log
echo " "     | tee -a error.log
sleep 9


if [[ `hostname` != "master" ]]; then
   # Change machine name
   echo " "     | tee -a ~/error.log
   echo "Will change machine name to 'master'..."  | tee -a error.log
   echo "------------------"     | tee -a ~/error.log
   sleep 9
   echo '[boot]' | sudo tee  /etc/wsl.conf > /dev/null
   echo 'systemd=true' | sudo tee -a /etc/wsl.conf > /dev/null
   echo '[network]' | sudo tee -a /etc/wsl.conf > /dev/null
   echo 'hostname = master' | sudo tee -a /etc/wsl.conf > /dev/null
   echo 'generateHosts = false' | sudo tee -a /etc/wsl.conf > /dev/null
   sudo rm /etc/resolv.conf
   echo 'nameserver 8.8.8.8' | sudo tee  /etc/resolv.conf > /dev/null
   sudo sed -i 's/127.0.1.1.*/127.0.1.1  master.fsm.ac.in   master/' /etc/hosts
else
   echo "It appears you have already executed this script."
   echo "Recheck.....and press ctrl+c  if yes."
   sleep 40
fi

# Install uv for langflow install
echo " "   | tee -a error.log
echo "Installing uv"  | tee -a error.log
echo "--------------"   | tee -a error.log
echo " "   | tee -a error.log
sleep 9
curl -LsSf https://astral.sh/uv/install.sh | sh   2>> error.log
echo " "     | tee -a ~/error.log
echo "uv installed"     | tee -a ~/error.log
sleep 9

# Move script file to done folder
mv ~/script1.sh ~/done
mv ~/next/script2.sh ~

# Shut down ubuntu
echo " "
echo "*******"
echo "Ubuntu terminal will be closed."
echo "Reopen it after it closes, and then execute the command:"
echo "     ./script2.sh"
echo "*******"
echo " "
sleep 9
exit

