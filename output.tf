output "vpc" {
  value = aws_vpc.devops-roadmap
}

output "internet_gateway" {
  value = aws_internet_gateway.internet-gw
}

output "subnets" {
  value = {
    public  = aws_subnet.public.*
    private = aws_subnet.private.*
  }
}

output "nat_gateways" {
  value = aws_nat_gateway.nat.*.public_ip
}

output "rds" {
  description = "RDS details"
  value       = {
    endpoint = aws_db_instance.rds.endpoint
    db_name = aws_db_instance.rds.name
    username = aws_db_instance.rds.username
    password = aws_db_instance.rds.password
  }
  sensitive = true
}
