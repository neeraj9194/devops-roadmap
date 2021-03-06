
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

resource "aws_instance" "service-box" {
  count           = var.instance_count
  ami             = data.aws_ami.ubuntu.id
  key_name        = aws_key_pair.awskeypair.key_name

  instance_type = "t2.micro"
  subnet_id = count.index == 0 || count.index == 1 ? aws_subnet.private[0].id : aws_subnet.private[count.index - 1].id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]

  tags = {
    Name = "service-box-${count.index}"
    Type = "service-host"
  }
}

resource "aws_ebs_volume" "storage" {
  count             = var.instance_count
  availability_zone = count.index == 0 || count.index == 1 ? data.aws_availability_zones.available.names[0] : data.aws_availability_zones.available.names[count.index - 1]
  size              = 8

  tags = {
    Name = "storage-service-box-${count.index}"
  }
}

resource "aws_volume_attachment" "service_box_attach" {
  count       = var.instance_count
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.storage[count.index].id
  instance_id = aws_instance.service-box[count.index].id
}


# Bastion Host

resource "aws_instance" "bastion-host" {
  count           = var.availability_zones_count
  ami             = data.aws_ami.ubuntu.id
  key_name        = aws_key_pair.awskeypair.key_name

  instance_type = "t2.micro"
  subnet_id = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  
  tags = {
    Name = "bastion-host-${count.index}"
    Type = "bastion-host"
  }
}

resource "aws_key_pair" "awskeypair" {
  key_name   = "awskeypair"
  public_key = file(var.key_path)
}
