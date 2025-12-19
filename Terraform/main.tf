data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default_subnet" {
  default_for_az   = true
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "my_group" {
  name        = "blue-green-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

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

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "blue" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default_subnet.id
  associate_public_ip_address = true
  key_name                    = "pem"
  vpc_security_group_ids      = [aws_security_group.my_group.id]
  user_data                   = file("Blue.sh")

  tags = {
    Name = "Blue"
  }
}


resource "aws_instance" "green" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default_subnet.id
  associate_public_ip_address = true
  key_name                    = "pem"
  vpc_security_group_ids      = [aws_security_group.my_group.id]
  user_data                   = file("Green.sh")

  tags = {
    Name = "Green"
  }
}

locals {
  active_ip = aws_instance.blue.private_ip
  # To switch traffic → change to:
  # active_ip = aws_instance.green.private_ip
}

resource "aws_instance" "nginx" {
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default_subnet.id
  associate_public_ip_address = true
  key_name                    = "pem"
  vpc_security_group_ids      = [aws_security_group.my_group.id]

  user_data = templatefile("nginx.sh.tpl", {
    ACTIVE_IP = local.active_ip
  })

  tags = {
    Name = "Nginx"
  }

  depends_on = [
    aws_instance.blue,
    aws_instance.green
  ]
}

output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}

output "blue_private_ip" {
  value = aws_instance.blue.private_ip
}

output "green_private_ip" {
  value = aws_instance.green.private_ip
}
