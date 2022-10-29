#!/bin/bash

# Add Tailscale’s package signing key and repository
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# update and upgrade OS and install tailscale
sudo systemctl stop unattended-upgrades.service
sudo apt update
sudo apt upgrade
sudo apt install tailscale
sudo systemctl start unattended-upgrades.service

# start tailscale
sudo tailscale up

# enable and configure firewall
sudo sed -i 's/IPV6=yes/IPV6=no/g' /etc/default/ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 22
sudo ufw allow 41641/udp

# reload firewall and ssh
sudo ufw reload
sudo service ssh restart
