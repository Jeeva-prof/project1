// Create Security Group
resource "aws_security_group" "app_SG" {
  name        = "healthcare_sg"
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "healthcare_sg"
  }
}
resource "aws_key_pair" "deployer" {
exit  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP/vYB7ZgCxcwRPGP4kJoPttUs5aCrsBWj0QdgBVdJ8D root@master"
}
resource "aws_instance" "EC2" {
  ami           = "ami-02018e94b500d5030" 
  instance_type = "t2.medium"
  key_name        = "deployer-key"
#  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.app_SG.id]
  associate_public_ip_address = true
  user_data = <<-EOF
                #! /bin/bash
                sudo wget https://raw.githubusercontent.com/Jeeva-prof/Deployment-script/refs/heads/main/k8s-master.sh
                sudo sh k8s-master.sh
        EOF
  
  tags = {
    Name = "master-server"
  }
  
}
resource "aws_instance" "EC21" {
  ami           = "ami-02018e94b500d5030" 
  instance_type = "t2.micro"
  key_name        = "deployer-key"
#  availability_zone = "ap-south-1a"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.app_SG.id]
  user_data = <<-EOF
                #! /bin/bash
                sudo wget https://raw.githubusercontent.com/Jeeva-prof/Deployment-script/refs/heads/main/k8s-nodes.sh
                sudo sh k8s-nodes.sh
        EOF
  tags = {
    Name = "node-server"
  }
  
}
