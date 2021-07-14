resource "aws_s3_bucket" "registry-bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "Registry bucket"
  }
}

