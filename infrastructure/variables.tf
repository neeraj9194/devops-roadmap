variable "region" {
    type = string
    default = "ap-south-1"
}

variable "availability_zones_count" {
    # considering only 2 because, ap-south 3rd zone does not support t2.micro (other's might). 
    # I can create data source to choose from a list like t3.micro but it may not be included in free tier.
    default = 2
}

variable "db_name" {
  description = "RDS DB name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Username of databse"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password of databse"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port of databse"
  type        = number
  default     = 3306
}

variable "db_engine" {
  description = "Database engine (mysql, postgres etc.) Default: mysql"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable key_path {
  type = string
  description = "SSH public generated manually"
  default = "~/.ssh/awskey.pub"
}

variable s3_bucket_name {
  type = string
  description = "Bucket name used for registry service."
}
