#!/bin/bash

set -e

print_message() {
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo or as root."
    exit 1
fi

print_message "Updating package list and installing prerequisites..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

print_message "Adding Docker’s official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

print_message "Setting up the Docker repository..."
UBUNTU_CODENAME=$(lsb_release -cs)
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $UBUNTU_CODENAME stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

print_message "Updating package list with Docker repository..."
apt-get update

print_message "Installing Docker Engine, CLI, Containerd, Buildx, and Compose..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

print_message "Verifying Docker installation by running hello-world container..."
docker run --rm hello-world

print_message "Creating Docker group..."
groupadd docker || echo "Docker group already exists."

print_message "Adding user '$SUDO_USER' to Docker group..."
usermod -aG docker "$SUDO_USER"

print_message "Applying new group membership..."

newgrp docker <<EOF
print_message "Running hello-world without sudo..."
docker run --rm hello-world
EOF

print_message "Docker installation and setup completed successfully!"

echo "You may need to log out and log back in for group changes to take full effect."
