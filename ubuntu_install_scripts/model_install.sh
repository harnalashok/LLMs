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



# Download ollama nomic-embed-text
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


echo " "
echo " Pulling text-embedding model"    | tee -a error.log
echo " "    | tee -a error.log
echo "--------- "    | tee -a error.log

ollama pull nomic-embed-text  2>> error.log
sleep 6
echo "Pulling olomo2 model"    | tee -a error.log
ollama pull olmo2  2>> error.log
sleep 5

# Move script file to done folder
mv ~/model_install.sh ~/done
mv ~/next/test.sh  ~
