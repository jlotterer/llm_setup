#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status messages
print_status() {
    echo "==> $1"
}

# Check if Docker is installed
if ! command_exists docker; then
    print_status "Docker not found. Installing Docker..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    print_status "Docker installed successfully"
else
    print_status "Docker is already installed"
fi

# Create temporary directory and clone repository
print_status "Creating temporary directory and cloning bolt.diy..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
git clone https://github.com/stackblitz-labs/bolt.diy.git
cd bolt.diy

# Initialize git repository (required for build)
print_status "Initializing git repository..."
git init
git config user.email "jlotterer@hotmail.com"
git config user.name "jlotterer"
git add .
git commit -m "Initial commit"

# Clean up Docker resources to ensure enough space
print_status "Cleaning up Docker resources..."
docker system prune -f

# Build Docker image
print_status "Building Docker image..."
DOCKER_BUILDKIT=0 docker build -t bolt-ai-development:latest . --target bolt-ai-development

# Clean up temporary directory
print_status "Cleaning up temporary files..."
cd
rm -rf "$TEMP_DIR"

print_status "Installation complete!"
print_status "To run bolt.diy, use the following command:"
echo "docker run -it --rm -p 5173:5173 bolt-ai-development:latest"
print_status "Then access the application at http://localhost:5173"

# Remind user to log out and back in if they weren't in docker group
if ! groups | grep -q docker; then
    print_status "IMPORTANT: Please log out and back in for Docker permissions to take effect"
fi
