To quickly install dockers for flowise+ollama+chromadb+n8n follow this script

```
  DIRECTORY=/home/$USER/Documents
  if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
  fi
   DIRECTORY=/home/$USER/Downloads
   if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
   fi
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_flowise_chroma_n8n.sh
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_flowise_chroma_n8n_ubuntu.sh
   #wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/docker%20commands.txt -P /home/$USER/Documents/docker/
   perl -pi -e 's/\r\n/\n/g' ~/ollama_flowise_chroma_n8n.sh
   chmod +x  ~/*.sh   
   bash ollama_flowise_chroma_n8n.sh
   cd ~/   
```
