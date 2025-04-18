provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "devops" {
  ami           = "ami-0261755bbcb8c4a84" # Ubuntu 20.04 LTS
  instance_type = "t3.large"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  root_block_device {
    volume_size = 40
  }

  tags = { Name = "devops-ec2" }
}

resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow DevOps ports"

  ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  ingress { from_port = 8080 to_port = 8080 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] } # Jenkins
  ingress { from_port = 9000 to_port = 9000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] } # SonarQube
  ingress { from_port = 9090 to_port = 9090 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] } # Prometheus
  ingress { from_port = 3000 to_port = 3000 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] } # Grafana
  ingress { from_port = 30080 to_port = 30080 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] } # App NodePort

  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

output "public_ip" { value = aws_instance.devops.public_ip }