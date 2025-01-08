#!/bin/bash

# Exit on any error
set -e

echo "Starting NVIDIA installation..."

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

echo "Installing Nvidia Toolkit..."
# Using yes command to pipe "y" responses to apt commands
# CUDA toolkit installer
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update


# CUDA driver install
sudo apt-get install -y cuda-drivers

# Nvidia driver install
sudo apt-get -y install nvidia-driver-565




# Add NVIDIA package repositories
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -fsSL https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update package listings
sudo apt-get update

# Install nvidia-container-toolkit
sudo apt-get install -y nvidia-container-toolkit


check_status "Installation"
echo "Nvidia installation completed!"
