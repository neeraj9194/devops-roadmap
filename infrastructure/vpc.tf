locals {
    cidr_block = "10.0.0.0/16"
    nat_gateways_count = var.availability_zones_count

    subnet_netnum = {
        public  = 0
        private = var.availability_zones_count
  }
}

# VPC

resource "aws_vpc" "devops-roadmap" {
  cidr_block = local.cidr_block

  tags = {
    Name = "devops-roadmap"
  }
}


# Subnets

resource "aws_subnet" "public" {
  count = var.availability_zones_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(local.cidr_block, 4, count.index + local.subnet_netnum.public)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.devops-roadmap.id

  tags = {
    Name = "public-${data.aws_availability_zones.available.names[count.index]}"
    SubnetType = "public"
  }
}

resource "aws_subnet" "private" {
  count = var.availability_zones_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(local.cidr_block, 4, count.index + local.subnet_netnum.private)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.devops-roadmap.id

  tags = {
    Name = "private-${data.aws_availability_zones.available.names[count.index]}"
    SubnetType = "private"
  }
}

# Internet gateway

resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.devops-roadmap.id
  tags = {
      Name = "internet-gw"
  }  
}


# Public NAT
resource "aws_eip" "nat" {
  count = local.nat_gateways_count
  vpc = true

  tags = {
    Name = "nat-ip"
  }

}

resource "aws_nat_gateway" "nat" {
  count = local.nat_gateways_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id 

  tags = {
    Name = "NAT-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gw]
}

