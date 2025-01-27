To begin installing all packages, execute the following five commands in *Ubuntu* console (whether Ubuntu machine or WSL).<br>
Copy and paste.


```
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/script0.sh
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/u_install/help.txt
   perl -pi -e 's/\r\n/\n/g' ~/script0.sh   
   chmod +x  ~/*.sh   
   bash script0.sh
   cd ~/   
```
Scripts assume that username is *'ashok'*. If that is not so, you can either replace */home/ashok/* with /home/\<username\>/ or with ~/.


File, `error.log`, in Ubutnu home folder, will indicate any errors in execution of scripts.
And file, info.log, keeps information about what all is installed.      
File <b><i>['help.txt'](https://github.com/harnalashok/LLMs/blob/main/u_install/help.txt)</i></b> contains information about ports, packages etc      

To read about *python virtual environments*, please [see this file](https://github.com/harnalashok/LLMs/blob/main/python%20venv) in my github.
   
------------     
Following software are intended to be installed/launched in a fresh wsl ubuntu,<br>
(Ubuntu version 22.04) the following software:<br><br>

>i)  Update/upgrade wsl ubuntu<br>
ii)  Changes the hostname of wsl ubuntu to 'master'<br>
iii) Installs uv<br>
iv)  Installs ollama<br>
To use gguf model in ollama, see [here](https://github.com/harnalashok/LLMs/blob/main/anythingLLM%20or%20ollama%20use%20any%20gguf%20model.md)
>> Start ollama, as:<br>
      
>>>  systemctl restart ollama<br>
>> OR, as   
>>>  ollama serve<br>

>v)   Installs llama.cpp<br>
vi)  Install Node.js<br>
vii)   Downloads  gemma-2 gguf from huggingface<br>
viii) Installs langflow<br>
ix) Installs flowise<br>
x) Installs tinyllama<br>
xi) Installs docker engine<br>
xii)Installs chromadb. Read more [here](https://github.com/harnalashok/LLMs/blob/main/quick%20chromadb%20install%20on%20wsl2.txt)
>> Start chromadb, as:<br>
>>>  systemctl restart chromadb<br>

>xii) Installs milvus. Read more about milvus [here](https://milvus.io/docs/install_standalone-docker.md).   
xii) Downloads: Llama-Thinker-3B-Preview-GGUF from huggingface<br>
xiii) Downloads: *nomic-embed-text* from *ollama library*<br>
xiv) Downloads *olmo2* from *ollama library*<br>



### Script sequence
<pre>
      # These sscripts run in sequence.
      #     script0.sh
      #     script1.sh
      #     script2.sh
      #     docker_install.sh
      #     script3.sh
      #     script4.sh
      #     script5.sh
</pre>

<pre>
   My WSL instalation has a number of folder paths with spaces. Putting 
PATH=$PATH:/home/ashok/llama.cpp/build/bin
PATH=$PATH:/home/ashok/.local/bin:/home/ashok/.local/bin:/run/user/1000/fnm_multishells/653_1737863874230/bin
PATH=$PATH:/home/ashok/.local/share/fnm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
PATH=$PATH:/usr/local/games:/usr/lib/wsl/lib:/mnt/c/windows/system32:/mnt/c/windows:/mnt/c/windows/System32/Wbem
PATH=$PATH:/mnt/c/windows/System32/WindowsPowerShell/v1.0/:/mnt/c/windows/System32/OpenSSH/:/mnt/c/'Program Files (x86)'/'NVIDIA Corporation'/PhysX/Common
PATH=$PATH:/mnt/c/'Program Files'/'NVIDIA Corporation'/'NVIDIA NvDLISR':/mnt/c/Users/Administrator/AppData/Local/Microsoft/WindowsApps
PATH=$PATH:/mnt/c/'Program Files'/HP/OMEN-Broadcast/Common:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem
PATH=$PATH:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/'Program Files'/HP/'HP One Agent'
PATH=$PATH:/mnt/c/'Program Files (x86)'/'Bitvise SSH Client':/mnt/c/Users/ashok/AppData/Local/Microsoft/WindowsApps:/mnt/c/Users/ashok/.lmstudio/bin
PATH=$PATH:/snap/bin:/home/ashok/llama.cpp/build/bin:/home/ashok/milvus/

   
</pre>



