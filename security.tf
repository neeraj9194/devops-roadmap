resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.devops-roadmap.id
  name        = "bastion-sg"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "bastion-sg"
  }
  
  depends_on = [aws_vpc.devops-roadmap]
}

resource "aws_security_group" "private_instance_sg" {
  vpc_id      = aws_vpc.devops-roadmap.id
  name        = "private-instance-sg"
  description = "Enable SSH access to the Private instances from the bastion via SSH port"

  ingress {
    description = "Incoming traffic from bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  
  tags = {
    Name = "private-instance-sg"
  }
  
  depends_on = [aws_vpc.devops-roadmap]
}


resource "aws_security_group" "rds_internal_sg" {
  name = "rds-internal-sg"

  description = "RDS application DB"
  vpc_id      = aws_vpc.devops-roadmap.id

  ingress {
    description     = "Allow traffic on 1 port internally."
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
  }

  egress {
    description = "Allow all outbound traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
