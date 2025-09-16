data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "${var.project}-key"
  public_key = var.ssh_public_key
}

resource "aws_security_group" "strapi_sg" {
  name        = "${var.project}-sg"
  description = "Allow SSH and Strapi HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Strapi HTTP"
    from_port   = 1337
    to_port     = 1337
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
    Name = "${var.project}-sg"
  }
}

resource "aws_instance" "strapi" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.project}-instance"
  }

  user_data = <<-EOT
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y docker.io
              systemctl enable --now docker
              mkdir -p /opt/strapi/app
              chown -R ubuntu:ubuntu /opt/strapi
              docker run -d --name strapi \
                --restart unless-stopped \
                -p 1337:1337 \
                -v /opt/strapi/app:/srv/app \
                strapi/strapi
              EOT
}
