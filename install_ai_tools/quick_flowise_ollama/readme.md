To quickly install dockers for flowise+ollama+chromadb+n8n follow this script       
Press <b>F2</b> at boot time to change 'Bios settings' (scroll down in the bios settings screen) for secure boot (UEFI). Also use <b>Audit Mode</b>

## Script for wsl-noGpu
```
  DIRECTORY=/home/$USER/Documents
  if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
  fi
   DIRECTORY=/home/$USER/Downloads
   if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
   fi

   DIRECTORY=/home/$USER/Documents/docker
   if [ ! -d "$DIRECTORY" ]; then
      mkdir -p $DIRECTORY
   fi

   #wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_gpu.sh
   wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_nogpu.sh
   #wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_flowise_chroma_n8n_ubuntu.sh
   wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/dockerCommands.txt -P /home/$USER/Documents/docker/

   perl -pi -e 's/\r\n/\n/g' ~/ollama_flowise_chroma_n8n_ubuntu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_gpu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_nogpu.sh
   chmod +x  ~/*.sh

   #bash ollama_flowise_chroma_n8n_ubuntu.sh
   #bash ollama_wsl_gpu.sh
   bash ollama_wsl_nogpu.sh
   cd ~/   
```

## Script for wsl-Gpu

```
  DIRECTORY=/home/$USER/Documents
  if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
  fi
   DIRECTORY=/home/$USER/Downloads
   if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
   fi

   DIRECTORY=/home/$USER/Documents/docker
   if [ ! -d "$DIRECTORY" ]; then
      mkdir -p $DIRECTORY
   fi

   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_gpu.sh
   #wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_nogpu.sh
   #wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_flowise_chroma_n8n_ubuntu.sh
   wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/dockerCommands.txt -P /home/$USER/Documents/docker/

   perl -pi -e 's/\r\n/\n/g' ~/ollama_flowise_chroma_n8n_ubuntu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_gpu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_nogpu.sh
   chmod +x  ~/*.sh

   #bash ollama_flowise_chroma_n8n_ubuntu.sh
   #bash ollama_wsl_nogpu.sh
   bash ollama_wsl_gpu.sh
   cd ~/   
```

## Script for ubuntu machine (gpu)

```
  DIRECTORY=/home/$USER/Documents
  if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
  fi
   DIRECTORY=/home/$USER/Downloads
   if [ ! -d "$DIRECTORY" ]; then
      mkdir $DIRECTORY
   fi

   DIRECTORY=/home/$USER/Documents/docker
   if [ ! -d "$DIRECTORY" ]; then
      mkdir -p $DIRECTORY
   fi

   #wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_gpu.sh
   #wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_wsl_nogpu.sh
   wget -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/quick_flowise_ollama/ollama_flowise_chroma_n8n_ubuntu.sh
   wget  -Nc https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/docker/dockerCommands.txt -P /home/$USER/Documents/docker/

   perl -pi -e 's/\r\n/\n/g' ~/ollama_flowise_chroma_n8n_ubuntu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_gpu.sh
   perl -pi -e 's/\r\n/\n/g' ~/ollama_wsl_nogpu.sh
   chmod +x  ~/*.sh

   bash ollama_flowise_chroma_n8n_ubuntu.sh
   #bash ollama_wsl_gpu.sh
   #bash ollama_wsl_nogpu.sh
   cd ~/   
```
