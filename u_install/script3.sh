#!/bin/bash

# LAst amended: 14th Jan, 2024

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




echo "========script3=============="
echo "Will install langflow using uv (but in virtual environment)"
echo "Will install Flowise directly using npm"
echo "Will prepare start script for each"
echo "Reboot and call script4.sh"
echo "==========================="
sleep 10


echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script3.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log


# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."                  | tee -a /home/ashok/error.log
echo "------"                                               | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
sleep 2

npm install -g flowise  2>> /home/ashok/error.log
echo " "
echo " "                                                    | tee -a /home/ashok/error.log
echo "flowise installed"                                    | tee -a /home/ashok/error.log
echo " "                                                    | tee -a /home/ashok/error.log
echo "flowise installed"                                    | tee -a /home/ashok/info.log
echo "flowise port is: 3000"                                | tee -a /home/ashok/info.log
echo " "                                                    | tee -a /home/ashok/info.log
echo "npx flowise start"                                    | tee -a /home/ashok/flowise_start.sh
chmod +x /home/ashok/*.sh



# Install langflow
echo " "                                      | tee -a /home/ashok/error.log
echo "Installing langflow..."                 | tee -a /home/ashok/error.log
echo "------"                                 | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log
sleep 2


uv venv
uv pip install langflow  2>> /home/ashok/error.log
sleep 2
echo "  "                                    | tee -a /home/ashok/error.log
echo "  "                                    | tee -a /home/ashok/info.log

echo "langflow installed"                    | tee -a /home/ashok/error.log
echo "langflow installed"                    | tee -a /home/ashok/info.log


# https://docs.langflow.org/configuration-cli
echo "Ref: https://docs.langflow.org/configuration-cli"      | tee -a /home/ashok/info.log
echo "Run following command to get langflow CLI options:"    | tee -a /home/ashok/info.log
echo "        uv run langflow"                               | tee -a /home/ashok/info.log
echo "Generate api-key, as: "                                | tee -a /home/ashok/info.log
echo "        uv run langflow api-key"                       | tee -a /home/ashok/info.log
echo "Run langflow, as:"                                     | tee -a /home/ashok/info.log
echo "        uv run langflow run"                           | tee -a /home/ashok/info.log
echo "---------- "                                           | tee -a /home/ashok/info.log
echo "  "                                                    | tee -a /home/ashok/info.log
echo "source .venv/bin/activate"                             | tee -a /home/ashok/langflow_start.sh
echo "uv run langflow run"                                   | tee -a /home/ashok/langflow_start.sh
chmod +x /home/ashok/*.sh
sleep 2


# Move script file to done folder
mv /home/ashok/script3.sh  /home/ashok/done
mv /home/ashok/next/script4.sh  /home/ashok/

#bash script4.sh
reboot
echo " "
echo "Shut down Ubuntu console"
echo "Reopen it and install  as:"
echo "  ./script4.sh"
echo "----------"
echo " "
exec sleep 10
exit


