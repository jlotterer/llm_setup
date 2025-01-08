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

echo "Uninstalling previous versions..."

sudo apt-get purge 'nvidia*'
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get remove --purge -V "nvidia-driver*" "libxnvctrl*"

# Remove Outdated Signing Key
sudo apt-key del 7fa2af80

# To clean up the uninstall
sudo apt-get autoremove --purge -V
# To remove CUDA Toolkit
sudo apt-get --purge remove "*cuda*" "*cublas*" "*cufft*" "*cufile*" "*curand*" \
 "*cusolver*" "*cusparse*" "*gds-tools*" "*npp*" "*nvjpeg*" "nsight*" "*nvvm*"
check_status "Uninstallation"




echo "Nvidia removal completed!"
