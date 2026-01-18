To quickly install dockers for flowise+ollama+chromadb+n8n follow these scripts. Copy and paste as per where you are installing.     
<b>NOTE:</b>  In CR1 lab (and possibly in <ins>Gurugram</ins> lab) where Symantic anti-virus is installed on Windows machines, this anti-virus must be stopped before working on WSL-ubuntu machines.    
(<b>For CR2 only</b>: Press <b>F2</b> at boot time to change 'Bios settings' (scroll down in the bios settings screen) for secure boot (UEFI). Also use <b>Audit Mode</b>)

## Script for wsl-noGpu
### For CR1 and For Gurugram labs     
Stop Symantic anti-virus first       
(copy and paste in WSL-Ubuntu terminal)
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
### For laptops with GPUs     
(copy and paste in WSL-Ubuntu terminal)

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
### For CR2 on Ubuntu machines     
(copy and paste in Ubuntu terminal)

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
