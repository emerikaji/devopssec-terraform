terraform {
  backend "s3" {
    region = "eu-north-1"
    bucket = "terraform-test-503718466266-eu-north-1-an"
    key = "states/terraform.tfstate"
  }
}

data "external" "random_name" {
  program = ["python3.12", "naming.py"]
}

provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_security_group" "sg_terraform" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["13.48.4.200/30"]
  }
}

resource "aws_instance" "ec2_terraform" {
  ami = data.aws_ami.amazon_linux_ami.id

  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.sg_terraform.id]

  user_data = file("user-data.yml")

  tags = {
    Name = "${data.external.random_name.result.random_name}-${terraform.workspace == "production" ? "prod" : "test"}"
  }
}
