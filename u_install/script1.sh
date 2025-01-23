#!/bin/bash

# Last amended: 23rd Jan, 2025


# Connected scripts are:
# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     script5.sh
#     script6.sh
#     script7.sh

# This file is called by script0.sh


echo " "                                       | tee -a /home/ashok/error.log
echo "*********"                               | tee -a /home/ashok/error.log
echo "Script: script1.sh"                      | tee -a /home/ashok/error.log
echo "**********"                              | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log



echo "  "
echo "------------"                            | tee -a /home/ashok/error.log
echo " Will update Ubuntu"                     | tee -a /home/ashok/error.log
echo " You will be asked for password...supply it..."
echo "----------"                              | tee -a /home/ashok/error.log
echo " "
sleep 2
sudo apt update
sudo apt upgrade -y
sudo apt install zip unzip net-tools cmake  build-essential python3-pip tilde curl git  python3-dev python3-venv gcc g++ make jq  -y  
echo " "
echo "Ubuntu upgraded ......"                | tee -a /home/ashok/error.log
echo "1. Ubuntu upgraded ......"             | tee -a /home/ashok/info.log

# Installing ollama
echo " "
echo " "
echo "------"
echo "Installing ollama quietly. Takes time...."  | tee -a /home/ashok/error.log
echo "When asked, supply password"
echo "No messages will appear on screen"
echo "------"
echo " "
echo " "
curl -fsSL https://ollama.com/install.sh | sh    2>> /home/ashok/error.log  
echo "---------"                                 | tee -a /home/ashok/error.log
echo "Ollama installed"                          | tee -a /home/ashok/error.log
echo "9. Ollama installed"                       | tee -a /home/ashok/info.log
echo "   ollama listens at port: 11434"          | tee -a /home/ashok/info.log
echo "-----------"                               | tee -a /home/ashok/error.log
echo " "                                         | tee -a /home/ashok/error.log
sleep 2



# Install 'fnm' (Fast Node Manager)
echo " "                                       | tee -a /home/ashok/error.log
echo "Will install fnm: Fast Node Manager..."  | tee -a /home/ashok/error.log
echo "------------------"                      | tee -a /home/ashok/error.log
sleep 9
sudo curl -fsSL https://fnm.vercel.app/install | bash   2>> /home/ashok/error.log
echo "Fast Node Manager (fnm) installed"       | tee -a /home/ashok/error.log
echo "2. Fast Node Manager (fnm) installed"    | tee -a /home/ashok/info.log


# Install chromadb
echo " "                                       | tee -a /home/ashok/error.log
echo " Will Install chromadb"                  | tee -a /home/ashok/error.log
echo "------------"                            | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
sleep 3
pip install chromadb   2>> /home/ashok/error.log
sleep 2

echo " "                                       | tee -a /home/ashok/error.log
echo "ChromaDB installed"                      | tee -a /home/ashok/error.log
echo "3. ChromaDB installed"                   | tee -a /home/ashok/info.log
echo "4. Database is at: /home/ashok/.local/bin/chroma"  | tee -a /home/ashok/info.log
echo "      chromadb port is: 8000"            | tee -a /home/ashok/info.log
eecho "------ "                                | tee -a /home/ashok/error.log

#  TO START CHROMA AS a SERVICE
#*********************************
cd ~/
echo '[Unit]'                       > chroma.service
echo "Description = Chroma Service" >> chroma.service
echo "After = network.target"       >> chroma.service
echo " "                            >> chroma.service
echo "[Service]"                    >> chroma.service
echo "Type = simple"                >> chroma.service
echo "User = root"                  >> chroma.service
echo "Group = root"                 >> chroma.service
echo "WorkingDirectory = /home/ashok/Documents"  >> chroma.service
echo "ExecStart=/home/ashok/.local/bin/chroma run --host 127.0.0.1 --port 8000 --path /home/ashok/Documents/data --log-path /var/log/chroma.log"  >> chroma.service
echo " "                             >> chroma.service
echo "[Install]"                     >> chroma.service
echo "WantedBy = multi-user.target"  >> chroma.service
sudo mv chroma.service /etc/systemd/system/chroma.service
#---------------------


# You can now start chroma, as:
echo " "                                       | tee -a /home/ashok/error.log
echo "5. ---Start/Stop Chroma as-------"       | tee -a /home/ashok/info.log
echo "     sudo systemctl daemon-reload"       | tee -a /home/ashok/info.log
echo "     sudo systemctl enable chroma"       | tee -a /home/ashok/info.log
echo "     sudo systemctl start chroma"        | tee -a /home/ashok/info.log
echo "6. Chroma is available at port 8000"     | tee -a /home/ashok/info.log
echo "7. Check as: "                           | tee -a /home/ashok/info.log
echo "      netstat -aunt | grep 8000"         | tee -a /home/ashok/info.log
echo "----------"                              | tee -a /home/ashok/info.log
echo " "                                       | tee -a /home/ashok/info.log
sleep 2


# Install uv for langflow install
echo " "                                       | tee -a /home/ashok/info.log
echo "Installing uv"                           | tee -a /home/ashok/info.log
echo "--------------"                          | tee -a /home/ashok/info.log
echo " "                                       | tee -a /home/ashok/info.log
sleep 2
curl -LsSf https://astral.sh/uv/install.sh | sh   2>> /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/error.log
echo " "                                       | tee -a /home/ashok/info.log
echo "uv installed"                            | tee -a /home/ashok/error.log
echo "8. uv installed"                         | tee -a /home/ashok/info.log
sleep 2

# Move script file to done folder
mv /home/ashok/script1.sh /home/ashok/done
mv /home/ashok/next/script2.sh /home/ashok/
bash script2.sh


# Shut down ubuntu
#echo " "
#echo "*******"
#echo "Ubuntu terminal will be closed."
#echo "Reopen it after it closes, and then execute the command:"
#echo "     ./script2.sh"
#echo "*******"
#echo " "
#exec sleep 9
#exit

