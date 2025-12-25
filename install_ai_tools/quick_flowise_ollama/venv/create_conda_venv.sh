#!/usr/bin/bash


# Last amended: 25th Dec, 2025

##############
# Create a conda python virtual env
# conda activate <env_name>
##############
echo " "
echo " ---"
echo "Script to create python conda virtual env"
echo " "
echo -n "What is the name of your new conda virtual env? "
read env_name
echo "Checking if $env_name exists"
abc=`(conda info --envs | grep $env_name)`

if [ -z "$abc" ]; then
    echo "No python conda environment by this name"
    echo -n "What python version would you like to install (example: 3.10) ? "
    read ver
    if [ -z "$ver" ]; then
       echo "No python version specified. Exiting"
       exit 1
    fi
else
    echo "conda env, $env_name, already exixts. Re-Check"
    sleep 4
    exit 2
fi

cd /home/$USER
echo " "
echo " "
echo "------------"        
conda create -n $env_name python=$ver spyder numpy scipy pandas matplotlib sympy cython jupyterlab wheel ipython notebook streamlit -y
conda init
conda activate $env_name
pip install --upgrade setuptools
# Required for spyder:
sudo apt install pyqt5-dev-tools -y
# Create script to activate '$env_name
echo '#!/bin/bash'                                                         | tee     /home/$USER/activate_$env_name.sh
echo "echo '(Note the change in prompt after activating)' "                | tee -a  /home/$USER/activate_$env_name.sh
echo "echo '(To deactivate, just enter the command: conda deactivate)' "   | tee -a  /home/$USER/activate_$env_name.sh
echo "echo 'Remove env as: conda remove --name <env_name> --all -y'"         | tee -a  /home/$USER/activate_$env_name.sh

echo "conda activate $env_name"                                            | tee -a  /home/$USER/activate_$env_name.sh
chmod +x /home/$USER/*.sh
sleep 2

cp /home/$USER/activate_$env_name.sh  /home/$USER/start/activate_$env_name.sh
cp /home/$USER/activate_$env_name.sh  /home/$USER/stop/activate_$env_name.sh
 
