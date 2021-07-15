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
    security_groups = [aws_security_group.bastion_sg.id]
  }
  
  ingress {
    description     = "http request from LB"
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    description     = "registery request from LB"
    from_port       = var.registry_port
    to_port         = var.registry_port
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  ingress {
    description     = "https request from LB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    security_groups = [aws_security_group.private_instance_sg.id]
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

resource "aws_security_group" "load_balancer_sg" {
  vpc_id      = aws_vpc.devops-roadmap.id
  name        = "load-balancer-sg"
  description = "Enable HTTP and HTTPS traffic to LB"
  
  ingress {
    description     = "http request from Internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description     = "https request from LB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "load-balancer-sg"
  }
  
  depends_on = [aws_vpc.devops-roadmap]
}