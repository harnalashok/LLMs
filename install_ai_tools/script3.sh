#!/bin/bash

# LAst amended: 8th July, 2025

cd ~/


echo "========script3=============="
echo "Will install ollama docker"
echo "Will install langflow using uv (but in virtual environment)"
echo "Will install Flowise using npm (node package manager)"
echo "Will prepare start script for each"
echo "Reboot and call script4.sh"
echo "==========================="
sleep 10


echo " "                                      | tee -a /home/$USER/error.log
echo "*********"                              | tee -a /home/$USER/error.log
echo "Script: script3.sh"                     | tee -a /home/$USER/error.log
echo "**********"                             | tee -a /home/$USER/error.log
echo " "                                      | tee -a /home/$USER/error.log


echo "Shall I install ollama docker? [Y,n]"
read input
input=${input:-n}
if [[ $input == "Y" || $input == "y" ]]; then
      # For model storage local folder ollama is mounted.
      echo "Local folder ollama for models is: /var/lib/docker/volumes/ollama/"
      echo "Will install ollama for GPU..."
      sleep 4
      docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
      # Start ollama docker in future
      echo '#!/bin/bash'                                                                                        > /home/$USER/start/start_docker_ollama.sh
      echo " "                                                                                                  >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '1. Run a model as: docker exec -it ollama ollama run <modelName>'"                            >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   and not as: ollama run <modelName>'"                                                       >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '2. Start/stop ollama docker: docker start/stop ollama'"                                       >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '3. Ollama is at port 11434'"                                                                  >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   Access as: http://host.docker.internal:11434'"                                             >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '   Or, as: http://hostip:11434 (hostip maybe: 172.17.0.1 but NOT 127.0.0.1)'"                 >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '4. Pull model from ollama library: ollama pull <modelName'"                                   >> /home/$USER/start/start_docker_ollama.sh
      echo "echo '5. Pulled models are available at /var/lib/docker/volumes/ollama/ '"                          >> /home/$USER/start/start_docker_ollama.sh
      chmod +x /home/$USER/start/*.sh
     
else
        echo "Skipping install of ollama docker"
fi


#####################
## Flowise install
####################


# 2.1 Install Flowise as NORMAL user
echo " "
echo "Installing flowvise...Takes time..."                  | tee -a /home/$USER/error.log
echo "------"                                               | tee -a /home/$USER/error.log
echo " "                                                    | tee -a /home/$USER/error.log
sleep 2

npm install -g flowise  2>> /home/$USER/error.log
echo " "
echo " "                                                    | tee -a /home/$USER/error.log
echo "flowise installed"                                    | tee -a /home/$USER/error.log
echo " "                                                    | tee -a /home/$USER/error.log
echo "flowise installed"                                    | tee -a /home/$USER/info.log
echo "flowise port is: 3000"                                | tee -a /home/$USER/info.log
echo " "                                                    | tee -a /home/$USER/info.log


echo '#!/bin/bash'                                           | tee    /home/$USER/start/start_npx_flowise.sh  
echo " "                                                     | tee -a /home/$USER/start/start_npx_flowise.sh
echo "cd ~/"                                                 | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo '----------'"                                                       | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo 'Will delete your earlier passwd, chatflows, Document Stores etc'"  | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo '----------'"                                                       | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo  -e '\033[33;5mTo avoid any deletions, start flowise as: \033[0m'" | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo '       ==> npx flowise start <=='"                                   | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo ' ' "                                                               | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo 'Press ctrl+c now to avoid deletions. Will wait for 10 secs.'"                  | tee -a /home/$USER/start/start_npx_flowise.sh
echo "sleep 15"                                              | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo 'Clearing now....'"                               | tee -a /home/$USER/start/start_npx_flowise.sh
echo "rm -r .flowise"                                        | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo 'Flowise will be available at port 3000'"         | tee -a /home/$USER/start/start_npx_flowise.sh
echo "echo 'Recommended userid/passwd: abc@fsm.ac.in / Abc@fsm123'"  | tee -a /home/$USER/start/start_npx_flowise.sh
echo "npx flowise start"                                     | tee -a /home/$USER/start/start_npx_flowise.sh
echo "netstat -aunt | grep 3000"                             | tee -a /home/$USER/start/start_npx_flowise.sh

ln /home/$USER/start/start_npx_flowise.sh /home/$USER/start_flowise.sh

# Start flowise in debug mode
echo '#!/bin/bash'                                                      | tee    /home/$USER/start/start_debug_flowise.sh  
echo " "                                                                | tee -a /home/$USER/start/start_debug_flowise.sh  
echo "cd ~/"                                                            | tee -a /home/$USER/start/start_debug_flowise.sh  
echo "echo 'Flowise will be available at port 3000 in debug mode'"      | tee -a /home/$USER/start/start_debug_flowise.sh  
echo "npx flowise start --DEBUG=true"                                   | tee -a /home/$USER/start/start_debug_flowise.sh  
echo "netstat -aunt | grep 3000"                                        | tee -a /home/$USER/start/start_debug_flowise.sh  
ln /home/$USER/start/start_debug_flowise.sh /home/$USER/start_flowise_debug.sh


# Update flowise
echo '#!/bin/bash'                                         | tee    /home/$USER/start/update_npx_flowise.sh  
echo " "                                                   | tee -a /home/$USER/start/update_npx_flowise.sh
echo "cd /home/$USER"                                      | tee -a /home/$USER/start/update_npx_flowise.sh
echo "echo 'Flowise will be updated'"                      | tee -a /home/$USER/start/update_npx_flowise.sh
echo "npm install -g flowise"                              | tee -a /home/$USER/start/update_npx_flowise.sh
echo " "                                                   | tee -a /home/$USER/start/update_npx_flowise.sh
echo " "                                                   | tee -a /home/$USER/start/update_npx_flowise.sh
echo "echo '============'"                                 | tee -a /home/$USER/start/update_npx_flowise.sh
echo "echo 'flowise version'"                              | tee -a /home/$USER/start/update_npx_flowise.sh
echo "echo '============'"                                 | tee -a /home/$USER/start/update_npx_flowise.sh
echo "flowise"                                             | tee -a /home/$USER/start/update_npx_flowise.sh
chmod +x /home/$USER/start/*.sh

#####################
## langflow install
####################

# Install langflow
echo " "                                      | tee -a /home/$USER/error.log
echo "Installing langflow..."                 | tee -a /home/$USER/error.log
echo "------"                                 | tee -a /home/$USER/error.log
echo " "                                      | tee -a /home/$USER/error.log
sleep 2


# Create default .venv environment in the current folder
# Existing environment is first deleted
uv venv
# Install in the default environment ie .venv
uv pip install langflow  2>> /home/$USER/error.log
sleep 2
echo "  "                                    | tee -a /home/$USER/error.log
echo "  "                                    | tee -a /home/$USER/info.log

echo "langflow installed"                    | tee -a /home/$USER/error.log
echo "langflow installed"                    | tee -a /home/$USER/info.log


# https://docs.langflow.org/configuration-cli
echo "Ref: https://docs.langflow.org/configuration-cli"      | tee -a /home/$USER/info.log
echo "Run following command to get langflow CLI options:"    | tee -a /home/$USER/info.log
echo "        uv run langflow"                               | tee -a /home/$USER/info.log
echo "Generate api-key, as: "                                | tee -a /home/$USER/info.log
echo "        uv run langflow api-key"                       | tee -a /home/$USER/info.log
echo "Run langflow, as:"                                     | tee -a /home/$USER/info.log
echo "        uv run langflow run"                           | tee -a /home/$USER/info.log
echo "---------- "                                           | tee -a /home/$USER/info.log
echo "  "                                                    | tee -a /home/$USER/info.log


echo '#!/bin/bash'                                         | tee    /home/$USER/start/start_uv_langflow.sh  
echo " "                                                   | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "cd ~/"                                               | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "echo 'Langflow will be available at port 7860'"      | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "echo 'deactivate venv with, deactivate, command'"    | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "source .venv/bin/activate"                           | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "uv run langflow run"                                 | tee -a /home/$USER/start/start_uv_langflow.sh  
echo "netstat -aunt | grep 3000"                           | tee -a /home/$USER/start/start_uv_langflow.sh  

chmod +x /home/$USER/start/*.sh

sleep 2


# Move script file to done folder
mv /home/$USER/script3.sh  /home/$USER/done
mv /home/$USER/next/script4.sh  /home/$USER/

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


