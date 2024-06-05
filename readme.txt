# Last amended: 5th June, 2024

sudo chmod -R 777 /usr/share/ollama
rm -r -f /home/ashok/ollama
sudo cp -r /usr/share/ollama  /home/ashok

sudo cp -r /home/ashok/ollama  /usr/share
sudo chmod -R 777 /usr/share/ollama