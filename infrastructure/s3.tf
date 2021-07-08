resource "aws_s3_bucket" "registery-bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "Registery bucket"
  }
}

