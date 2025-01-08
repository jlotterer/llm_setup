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
# Using yes command to pipe "y" responses to apt commands
yes | sudo apt-get purge 'nvidia*'
yes | sudo apt-get -y autoremove
yes | sudo apt-get autoclean
yes | sudo apt-get remove --purge -V "nvidia-driver*" "libxnvctrl*"

# Remove Outdated Signing Key
sudo apt-key del 7fa2af80 2>/dev/null || true

# To clean up the uninstall
yes | sudo apt-get autoremove --purge -V

# To remove CUDA Toolkit
yes | sudo apt-get --purge remove "*cuda*" "*cublas*" "*cufft*" "*cufile*" "*curand*" \
 "*cusolver*" "*cusparse*" "*gds-tools*" "*npp*" "*nvjpeg*" "nsight*" "*nvvm*"

check_status "Uninstallation"
echo "Nvidia removal completed!"
