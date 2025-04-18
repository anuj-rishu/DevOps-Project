#!/bin/bash

sudo apt-get update
sudo apt-get install -y docker.io docker-compose curl git

# Install K3s (lightweight Kubernetes)
curl -sfL https://get.k3s.io | sh -

# Add user to docker group
sudo usermod -aG docker $USER

# (Optional) Install kubectl
sudo snap install kubectl --classic