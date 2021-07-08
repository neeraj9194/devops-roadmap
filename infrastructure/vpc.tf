locals {
  cidr_block         = "10.0.0.0/16"

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
    Name       = "public-${data.aws_availability_zones.available.names[count.index]}"
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
    Name       = "private-${data.aws_availability_zones.available.names[count.index]}"
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

# route to connect public subnet to Internet GW
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.devops-roadmap.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }
}

resource "aws_route_table_association" "public-rta" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public-rt.id
}


# Single Public NAT for all AZ, in real world this might not be the case.
# This is not HA Nat Gateway https://packetswitch.co.uk/aws-nat-gateway-high-availability/
resource "aws_eip" "nat" {
  vpc   = true

  tags = {
    Name = "nat-ip"
  }

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gw]
}

# route to connect private subnet to NAT
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.devops-roadmap.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private-rta" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
