#!/bin/bash

read -p $' \e[32mNgrok Authtoken: \e[0m' NGROK_AUTH_TOKEN

apt update > /dev/null 2>&1
apt install python3 -y > /dev/null 2>&1
apt install python3-pip -y > /dev/null 2>&1
pip3 install byobu > /dev/null 2>&1
apt install screen -y > /dev/null 2>&1
pip3 install bpytop > /dev/null 2>&1
apt install jq -y > /dev/null 2>&1

screen -ls | grep -o '[0-9]*\.[a-zA-Z0-9]*' | while read -r line; do screen -S "$line" -X quit; done
rm proxy -rf
mkdir proxy && cd proxy

wget https://github.com/YongSheng109/temp/raw/main/ngrok-v3-stable-linux-amd64.tgz > /dev/null 2>&1
tar -xvzf ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin > /dev/null 2>&1
wget https://github.com/YongSheng109/temp/raw/main/proxy > /dev/null 2>&1
wget https://raw.githubusercontent.com/YongSheng109/temp/main/ZBProxy.json > /dev/null 2>&1
chmod 777 *

ngrok config add-authtoken $NGROK_AUTH_TOKEN > /dev/null 2>&1

screen -S proxy -d -m ./proxy
screen -S ngrok -d -m ngrok tcp 25565
screen -S afk -d -m bpytop

sleep 2
ngrok_address=$(curl -s http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "tcp") | .public_url' | sed 's/tcp:\/\///')
clear
echo -e "\e[32m IP\e[0m \e[97m$ngrok_address\e[0m"
