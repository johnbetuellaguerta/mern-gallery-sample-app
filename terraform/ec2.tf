resource "aws_instance" "ec2_mongodb" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.database_sg.id]
  associate_public_ip_address = false
  user_data                   = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install git -y
                                git config --global user.name "jbetueldev"
                                git config --global user.email "johnbetuel.dev@gmail.com"
                                yum install docker -y
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                sudo usermod -a -G docker ec2-user
                                curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
                                chmod +x /usr/local/bin/docker-compose
                              EOF
  tags = {
    Name = "EC2 Mongodb"
  }
}

resource "aws_instance" "backend_instance" {
  count                       = 3
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = false
  user_data                   = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install git -y
                                git config --global user.name "jbetueldev"
                                git config --global user.email "johnbetuel.dev@gmail.com"
                                yum install docker -y
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                sudo usermod -a -G docker ec2-user
                              EOF
  tags = {
    Name = "backend-instance-${count.index + 1}"
  }
}

resource "aws_instance" "frontend_instance" {
  count                       = 2
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install git -y
                                git config --global user.name "jbetueldev"
                                git config --global user.email "johnbetuel.dev@gmail.com"
                                yum install docker -y
                                sudo systemctl start docker
                                sudo systemctl enable docker
                                sudo usermod -a -G docker ec2-user
                                curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
                                chmod +x /usr/local/bin/docker-compose
                              EOF
  tags = {
    Name = "frontend-instance-${count.index + 1}"
  }
}

resource "aws_instance" "proxy_server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.proxy_sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
                                #!/bin/bash
                                yum update -y
                                yum install git -y
                                git config --global user.name "jbetueldev"
                                git config --global user.email "johnbetuel.dev@gmail.com"
                                yum install nginx -y
                                sudo systemctl start nginx
                                sudo systemctl enable nginx
                              EOF
  tags = {
    Name = "Proxy server"
  }
}