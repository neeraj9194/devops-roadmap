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

# pgp_key must be used to protect secrets.
output "s3_read_user_secret" {
  value = {
    name = aws_iam_user.s3_read_only.name
    secret = aws_iam_access_key.s3_read_only.secret
    }
  sensitive   = true
}

output "s3_rw_user_secret" {
  value = {
    name = aws_iam_user.s3_read_write.name
    secret = aws_iam_access_key.s3_read_write.secret
    }
  sensitive   = true
}

output "dns" {
  description = "DNS endpoint for application load balancer."
  value       = aws_lb.application_lb.dns_name
}
