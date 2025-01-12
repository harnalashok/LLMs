These files are intended to launch in a fresh wsl ubuntu,<br>
(Ubuntu version 22.04) the following software:<br><br>

i)   Update/upgrade wsl ubuntu<br>
ii)  Changes the hostname of wsl ubuntu to 'master'<br>
iii) Installs uv<br>
iv)  Installs ollama<br>
> Start ollama, as:<br>
      
>>  systemctl restart ollama<br>
>>  ollama serve<br>

v)   Installs llama.cpp<br>
vi)  Install Node.js<br>
vii)   Downloads  gemma-2 gguf from huggingface<br>
viii) Installs langflow<br>
ix) Installs flowise<br>
x) Installs tinyllama<br>
xi) Installs docker engine<br>
xii) Downloads: Llama-Thinker-3B-Preview-GGUF from huggingface<br>
xiii) Downloads: nomic-embed-text from *ollama library*<br>
xiv) Downloads olmo2 from *ollama library*<br>

To begin, execute the following four commands in Ubuntu console.<br>
Copy and paste.

<pre>
   wget -c https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/scripts/script0.sh   
   perl -pi -e 's/\r\n/\n/g' /home/ashok/script0.sh   
   chmod +x /home/ashok/*.sh   
   bash script0.sh   
</pre>
