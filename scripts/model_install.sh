# Test scripts

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     docker_install.sh
#     script4.sh
#     model_install.sh
#     test.sh


echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: model_install.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log

if netstat -aunt   |  grep '11434'; then  
   echo " "      | tee -a error.log
   echo "Ollama is already started"     | tee -a error.log
   echo " "      | tee -a error.log
 else  
    # Download ollama nomic-embed-text
    # Start ollama in background
    echo " "    | tee -a error.log
    echo "-----------"    | tee -a error.log
    echo "Starting ollama in background"    | tee -a error.log
    echo "---------"    | tee -a error.log
    echo " "    | tee -a error.log
    ollama serve &  > /dev/null &
fi


echo " "    | tee -a error.log
echo " Pulling text-embedding model for ollama"    | tee -a error.log
echo " "    | tee -a error.log
echo "--------- "    | tee -a error.log
ollama pull nomic-embed-text  2>> error.log
sleep 6
echo "nomic-embed-text pulled"   | tee -a error.log
echo "------- "    | tee -a error.log
echo " "    | tee -a error.log

echo " "    | tee -a error.log
echo "Will pull olom2 model, next. File size: 4.5gb"  | tee -a error.log
read -p "Shall I go ahead and pull olom2 model (yY/nN? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo " "    | tee -a error.log
    echo "OK. Pulling olomo2 model"    | tee -a error.log
    ollama pull olmo2  2>> error.log
sleep 5
fi

# Move script file to done folder
mv /home/ashok/model_install.sh /home/ashok/done
mv /home/ashok/next/test.sh  /home/ashok
sleep 2
wsl.exe --shutdown

