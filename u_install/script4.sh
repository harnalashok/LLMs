#!/bin/bash

# REf: https://github.com/mudler/LocalAI

 # These scripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     ubuntu_docker1.sh
      #     ubuntu_docker2.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
      #     script6.sh
      #     script7.sh
      #     script8.sh
      #     script9.sh



echo "========script7=============="
echo "Will create script to create postgresql user/database"  
echo "Needed for RecordManager"
echo "Will install LocalAI docker"
echo "==========================="
sleep 10

# Create a script, that will inturn, help create user and password
# in postgresql

echo "#!/bin/bash"                                                                         > /home/ashok/createpostgresuser.sh
echo " "                                                                                  >>   /home/ashok/createpostgresuser.sh
echo "echo 'Ref: https://stackoverflow.com/a/2172588'"                                    >>   /home/ashok/createpostgresuser.sh
echo "echo 'Will open psql shell to create user, password and his database'"              >>   /home/ashok/createpostgresuser.sh
echo "echo 'Write below a user LOGIN password, mypass, within single inverted commas'"    >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE ROLE myuser LOGIN PASSWORD mypass ; '"                                 >>   /home/ashok/createpostgresuser.sh
echo "echo 'CREATE DATABASE mydatabase WITH OWNER = myuser;'"                             >> /home/ashok/createpostgresuser.sh
echo "echo 'To quit psql shell enter \\q'"                                                >> /home/ashok/createpostgresuser.sh
echo "sleep 10"                                                                           >> /home/ashok/createpostgresuser.sh
# To open psql shell to enter DDL/DML commands
echo "sudo -u postgres psql postgres"                                                     >> /home/ashok/createpostgresuser.sh
chmod +x /home/ashok/*.sh

mv /home/ashok/script4.sh       /home/ashok/done/
mv /home/ashok/next/script5.sh  /home/ashok/


mkdir /home/ashok/localai
cd /home/ashok/localai
# Should run in detached mode
docker run -ti -d --name local-ai -p 8080:8080 localai/localai:latest-cpu

echo "Download localai model"
echo "Process will run in background"
sleep 5

# Start local-ai in future
echo "#!/bin/bash"                                                                         > /home/ashok/start/start_localai.sh
echo " "                                                                                  >> /home/ashok/start/start_localai.sh
echo "cd /home/ashok/localai"                                                                >> /home/ashok/start/start_localai.sh
echo "docker start local-ai"                                                              >> /home/ashok/start/start_localai.sh
chmod +x /home/ashok/start/*.sh

# Stop local-ai in future
echo "#!/bin/bash"                                                                         > /home/ashok/stop/stop_localai.sh
echo " "                                                                                  >> /home/ashok/stop/stop_localai.sh
echo "cd /home/ashok/localai"                                                                >> /home/ashok/stop/stop_localai.sh
echo "docker stop local-ai"                                                              >> /home/ashok/stop/stop_localai.sh
chmod +x /home/ashok/stop/*.sh

# Download two sh files to download models
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel1.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_localaiModel2.sh    -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/download_stablediffusion.sh   -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/get_download_status.sh        -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/find_file.sh                  -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/find_file.sh                  -P /home/ashok/


# Download to files to create create images

wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/generate_image.sh   -P /home/ashok/localai
wget -c  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/localai/generate_image2.sh  -P /home/ashok/localai
chmod +x /home/ashok/localai/*.sh

cd ~/
echo "You may like to execute:"
echo "       ./script5.sh"
sleep 10
reboot

