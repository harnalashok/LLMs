# Test scripts

# These sscripts run in sequence.
#     script0.sh
#     script1.sh
#     script2.sh
#     script3.sh
#     script4.sh
#     docker_install.sh
#     model_install.sh
#     test.sh


echo " " | tee -a error.log
echo "*********"  | tee -a error.log
echo "Script: model_install.sh"  | tee -a error.log
echo "**********" | tee -a error.log
echo " " | tee -a error.log



# Download ollama nomic-embed-text
# Start ollama in background
echo " "    | tee -a error.log
echo "-----------"    | tee -a error.log
echo "Starting ollama in background"    | tee -a error.log
echo "---------"    | tee -a error.log
echo " "    | tee -a error.log
ollama serve &  > /dev/null &

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
mv /home/ashok/model_install.sh /home/ashok/done
mv /home/ashok/next/test.sh  /home/ashok
