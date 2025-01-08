#!/bin/bash

# Exit on any error
set -e

echo "Starting Docker installation..."

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run this script as root"
    exit 1
fi

# Function to check command status
check_status() {
    if [ $? -eq 0 ]; then
        echo "✓ $1"
    else
        echo "✗ $1 failed"
        exit 1
    fi
}

echo "Installing Docker dependencies..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg
check_status "Dependencies installation"

echo "Setting up Docker repository..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
check_status "GPG key setup"

echo "Adding Docker APT repository..."
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
check_status "Repository setup"

echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
check_status "Docker installation"

echo "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker
check_status "Docker service setup"

echo "Checking Docker installation..."
sudo docker version
sudo systemctl status docker
check_status "Docker status check"

echo "Setting up user permissions..."
sudo usermod -aG docker $USER
check_status "User permissions setup"

echo "Docker installation completed!"
echo "Please log out and log back in for group changes to take effect."
echo "Alternatively, run 'newgrp docker' in your terminal."
echo ""
echo "To test Docker, run: docker run hello-world"