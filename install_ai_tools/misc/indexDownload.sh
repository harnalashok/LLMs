echo "Downloading 'index.html' file"
echo "Folder: Documents/apache2/"
sleep 5
mkdir -p /home/$USER/Documents/apache2
cd /home/$USER/Documents/apache2
wget -Nc  https://raw.githubusercontent.com/harnalashok/LLMs/refs/heads/main/install_ai_tools/misc/index.html
echo "=========="
echo "After modifying the 'index.html' file, execute: mvindex.sh"
echo "To move it to web-server: /var/www/html/"
