terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "devops-roadmap"
    key    = "state"
    region = "ap-south-1"
  }

}

provider "aws" {
  region = var.region
}

module "inventory" {
  source = "./modules/inventory"
  s3_read_only = {
    id = aws_iam_access_key.s3_read_only.id
    secret = aws_iam_access_key.s3_read_only.secret
  }
  s3_read_write = {
    id = aws_iam_access_key.s3_read_write.id
    secret = aws_iam_access_key.s3_read_write.secret
  }
}