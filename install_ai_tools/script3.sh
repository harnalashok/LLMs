#!/bin/bash

# LAst amended: 30th June, 2025

cd ~/


echo "========script3=============="
echo "Will install ollama docker"
echo "Will install langflow using uv (but in virtual environment)"
echo "Will install Flowise using npm (node package manager)"
echo "Will prepare start script for each"
echo "Reboot and call script4.sh"
echo "==========================="
sleep 10


echo " "                                      | tee -a /home/ashok/error.log
echo "*********"                              | tee -a /home/ashok/error.log
echo "Script: script3.sh"                     | tee -a /home/ashok/error.log
echo "**********"                             | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log


echo "Shall I install ollama docker? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
      # For model storage local folder ollama is mounted.
      echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
      echo "Will install ollama for GPU..."
      sleep 4
      docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
      # Start ollama docker in future
      echo '#!/bin/bash'                                                                                        > /home/ashok/start/start_docker_ollama.sh
      echo " "                                                                                                  >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '1. Run a model as: docker exec -it ollama ollama run <modelName>'"                            >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '   and not as: ollama run <modelName>'"                                                       >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '2. Start/stop ollama docker: docker start/stop ollama'"                                       >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '3. Ollama access at port 11434'"                                                              >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '   Or, access as: http://host.docker.internal:11434'"                                         >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '4. Pull model from ollama library: ollama pull <modelName'"                                   >> /home/ashok/start/start_docker_ollama.sh
      echo "echo '5. Pulled models are available at /var/lib/docker/volumes/ollama/ '"                          >> /home/ashok/start/start_docker_ollama.sh
      chmod +x /home/ashok/start/*.sh
     
else
        echo "Skipping install of ollama docker"
fi


#####################
## Flowise install
####################


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


echo '#!/bin/bash'                                           | tee    /home/ashok/start/start_npx_flowise.sh  
echo " "                                                     | tee -a /home/ashok/start/start_npx_flowise.sh
echo "cd ~/"                                                 | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo '----------'"                                                       | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Will delete your earlier passwd, chatflows, Document Stores etc'"  | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo '----------'"                                                       | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo  -e '\033[33;5mTo avoid any deletions, start flowise as: \033[0m'" | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo '       ==> npx flowise start <=='"                                   | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Press ctrl+c now to avoid deletions. Will wait for 10 secs.'"                  | tee -a /home/ashok/start/start_npx_flowise.sh
echo "sleep 15"                                              | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Clearing now....'"                               | tee -a /home/ashok/start/start_npx_flowise.sh
echo "rm -r .flowise"                                        | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Flowise will be available at port 3000'"         | tee -a /home/ashok/start/start_npx_flowise.sh
echo "echo 'Recommended userid/passwd: abc@fsm.ac.in / Abc@fsm123'"  | tee -a /home/ashok/start/start_npx_flowise.sh
echo "npx flowise start"                                     | tee -a /home/ashok/start/start_npx_flowise.sh
echo "netstat -aunt | grep 3000"                             | tee -a /home/ashok/start/start_npx_flowise.sh

# Start flowise in debug mode
echo '#!/bin/bash'                                                      | tee    /home/ashok/start/start_debug_flowise.sh  
echo " "                                                                | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "cd ~/"                                                            | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "echo 'Flowise will be available at port 3000 in debug mode'"      | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "npx flowise start --DEBUG=true"                                   | tee -a /home/ashok/start/start_debug_flowise.sh  
echo "netstat -aunt | grep 3000"                                        | tee -a /home/ashok/start/start_debug_flowise.sh  

# Update flowise
echo '#!/bin/bash'                                         | tee    /home/ashok/start/update_npx_flowise.sh  
echo " "                                                   | tee -a /home/ashok/start/update_npx_flowise.sh
echo "cd /home/ashok"                                      | tee -a /home/ashok/start/update_npx_flowise.sh
echo "echo 'Flowise will be updated'"                      | tee -a /home/ashok/start/update_npx_flowise.sh
echo "npm install -g flowise"                              | tee -a /home/ashok/start/update_npx_flowise.sh
echo " "                                                   | tee -a /home/ashok/start/update_npx_flowise.sh
echo " "                                                   | tee -a /home/ashok/start/update_npx_flowise.sh
echo "echo '============'"                                 | tee -a /home/ashok/start/update_npx_flowise.sh
echo "echo 'flowise version'"                              | tee -a /home/ashok/start/update_npx_flowise.sh
echo "echo '============'"                                 | tee -a /home/ashok/start/update_npx_flowise.sh
echo "flowise"                                             | tee -a /home/ashok/start/update_npx_flowise.sh
chmod +x /home/ashok/start/*.sh

#####################
## langflow install
####################

# Install langflow
echo " "                                      | tee -a /home/ashok/error.log
echo "Installing langflow..."                 | tee -a /home/ashok/error.log
echo "------"                                 | tee -a /home/ashok/error.log
echo " "                                      | tee -a /home/ashok/error.log
sleep 2


# Create default .venv environment in the current folder
# Existing environment is first deleted
uv venv
# Install in the default environment ie .venv
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


echo '#!/bin/bash'                                         | tee    /home/ashok/start/start_uv_langflow.sh  
echo " "                                                   | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "cd ~/"                                               | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "echo 'Langflow will be available at port 7860'"      | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "echo 'deactivate venv with, deactivate, command'"    | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "source .venv/bin/activate"                           | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "uv run langflow run"                                 | tee -a /home/ashok/start/start_uv_langflow.sh  
echo "netstat -aunt | grep 3000"                           | tee -a /home/ashok/start/start_uv_langflow.sh  

chmod +x /home/ashok/start/*.sh

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


