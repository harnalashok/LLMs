To quickly install dockers for flowise+ollama+chromadb+n8n follow this script

```
  DIRECTORY=/home/ashok/Documents
  if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
  fi
   DIRECTORY=/home/ashok/Downloads
   if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
   fi
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/script0.sh
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/help.txt
   ln -sT /home/ashok/help.txt /home/ashok/Documents/help.txt
   perl -pi -e 's/\r\n/\n/g' ~/script0.sh   
   chmod +x  ~/*.sh   
   bash script0.sh
   cd ~/   
```
