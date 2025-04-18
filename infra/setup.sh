#!/bin/bash
# filepath: infra/setup.sh

sudo apt-get update
sudo apt-get install -y docker.io docker-compose curl git

# Install K3s (lightweight Kubernetes)
curl -sfL https://get.k3s.io | sh -

# Install Jenkins
docker run -d --name jenkins -p 8080:8080 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

# Install SonarQube
docker run -d --name sonarqube -p 9000:9000 sonarqube:community

# Install Prometheus
mkdir -p ~/prometheus
cat <<EOF > ~/prometheus/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
docker run -d --name prometheus -p 9090:9090 -v ~/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

# Install Grafana
docker run -d --name grafana -p 3000:3000 grafana/grafana

# Add user to docker group
sudo usermod -aG docker $USER