provider "aws" {
  region = var.aws_region
}

# Auto-find latest Ubuntu 22.04 LTS AMI for the region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "portfolio_sg" {
  name        = "portfolio-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "portfolio-sg"
  }
}

# Key Pair (uses your local public key)
resource "aws_key_pair" "portfolio_key" {
  key_name   = "portfolio-key"
  public_key = file("~/.ssh/portfolio_key.pub")
}

# EC2 Instance
resource "aws_instance" "portfolio" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.portfolio_key.key_name
  vpc_security_group_ids = [aws_security_group.portfolio_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    docker pull ${var.docker_image}
    docker run -d -p 80:80 --restart always --name portfolio ${var.docker_image}
  EOF

  tags = {
    Name = "portfolio-server"
  }
}
