#!/usr/bin/bash


# LAst amended: 13th Dec, 2025

##############
# Create a python virtual env
# source /home/$USER/<env_name>/bin/activate
##############

echo -n "What is the name of your new python virtual env? "
read env_name
echo "Checking if $env_name exists"

DIR="/home/$USER/$env_name"

if [ -d "$DIR" ]; then
    echo "Directory $DIR exists."
	echo "Possible python env, $env_name, already exixts. Check"
    sleep 4
	exit 2
else
    echo "Directory $DIR does not exist."
	echo "So no python environment"
fi

cd /home/$USER
echo " "
echo " "
echo "------------"        
# Clear earlier directory, if it exists
python3 -m venv --clear /home/$USER/$env_name
source /home/$USER/$env_name/bin/activate
# 1.6 Essentials software
pip install spyder numpy scipy pandas matplotlib sympy cython
pip install jupyterlab
pip install wheel
pip install ipython
pip install notebook
pip install streamlit
pip install --upgrade setuptools
# Required for spyder:
sudo apt install pyqt5-dev-tools -y
# Create script to activate '$env_name
echo '#!/bin/bash'                                                             | tee   /home/$USER/activate_$env_name.sh
echo "echo 'Execute this file as: source activate_$env_name.sh' "              | tee -a  /home/$USER/activate_$env_name.sh
echo "echo 'To use or install any python package, first activate python venv as:' "        | tee -a  /home/$USER/activate_$env_name.sh
echo "echo 'source /home/$USER/$env_name/bin/activate' "                        | tee -a  /home/$USER/activate_$env_name.sh
echo "echo '(Note the change in prompt after activating)' "                | tee -a  /home/$USER/activate_$env_name.sh
echo "echo '(To deactivate, just enter the command: deactivate)' "         | tee -a  /home/$USER/activate_$env_name.sh
echo "source /home/$USER/$env_name/bin/activate"                           | tee -a  /home/$USER/activate_$env_name.sh
chmod +x /home/$USER/*.sh
sleep 2

cp /home/$USER/activate_$env_name.sh  /home/$USER/start/activate_$env_name.sh
cp /home/$USER/activate_$env_name.sh  /home/$USER/stop/activate_$env_name.sh
 
