locals {
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = local.subnet_ids
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  port                   = var.db_port
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_internal_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
}
