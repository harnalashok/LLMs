To begin installing all packages, execute the following four commands in *Ubuntu* console.<br>
Copy and paste.


```
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/ubuntu_install_scripts/script0.sh   
   perl -pi -e 's/\r\n/\n/g' ~/script0.sh   
   chmod +x  ~/*.sh   
   bash script0.sh
   cd ~/   
```


File, `error.log`, in Ubutnu home folder, will indicate any errors in execution of scripts.   
   
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



### RAM allocation

> To allocate more RAM to WSL Ubuntu, first check how much RAM it has using the `free` command. Then create the following file in Windows at c:\users\<userName>\.wslconfig (for example: c:\users\ubuntu\.wslconfig).   

```
[wsl2]
memory=10GB
```

>Note that 'GB' must be in capital case. See these links: [one](https://stackoverflow.com/a/73393648/3282777) and [two](https://stackoverflow.com/a/79276209/3282777).   

> Execute the following command in `Powershell` to automatically create the file at the desired location:  

```
Write-Output "[wsl2]
memory=26GB" > "${env:USERPROFILE}\.wslconfig"
```

> Shutdown ubuntu (`wsl --shutdown`) and restart it for it to take effect.
>
### Script sequence
<pre>
       These scripts run in sequence in Ubuntu Console.
           script0.sh
           script1.sh
           script2.sh
           script3.sh
           docker_install.sh
           script4.sh
           model_install.sh
           test.sh
</pre>



