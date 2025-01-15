

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
