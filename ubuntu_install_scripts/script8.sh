#!/bin/bash

echo "**************"
echo "Be WARNED that Anaconda 'base' environment will hide
echo "   your existing python environment."
echo "Deactivate base environment while using other "
echo " python environments with the command:"
echo "      conda deactivate
echo "**************"
sleep 9

# Install Anaconda
echo " "
echo "Downloading Anaconda" | tee -a ~/error.log
wget -c https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-2024.10-1-Linux-x86_64.sh -b
sleep 2
echo "Anaconda installed" | tee -a ~/info.log
rm Anaconda3-2024.10-1-Linux-x86_64.sh
echo "PATH=\$PATH:~/anaconda3/bin/" >> ~/.bashrc

echo " "  | tee -a ~/info.log
echo " ---------" | tee -a ~/error.log
echo "To begin using Anaconda, you need to initialise it, as"  | tee -a ~/info.log
echo "      conda init "  | tee -a ~/info.log
echo "      Bring base environment,  as: conda activate " >> ~/info.log
echo "      Remove base environment, as:  conda deactivate " >> ~/info.log
echo "------"  | tee -a ~/info.log
echo " "  | tee -a ~/info.log
