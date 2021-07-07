
locals {
    # Three service machines(2+1 AZ).
    instance_count = var.availability_zones_count + 1
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}


resource "aws_network_interface" "service-box" {
    count       = local.instance_count
    subnet_id   = count.index == 0 || count.index == 1 ? aws_subnet.private[0].id : aws_subnet.private[count.index - 1].id
    tags = {
        Name = "ec2_network_interface"
    }
}


resource "aws_instance" "service-box" {
    count         = local.instance_count
    ami           = data.aws_ami.ubuntu.id

    instance_type = "t2.micro"

    network_interface {

        network_interface_id = aws_network_interface.service-box[count.index].id
        device_index         = 0
    }

    tags = {
        Name = "service-box-${count.index}"
    }
}
