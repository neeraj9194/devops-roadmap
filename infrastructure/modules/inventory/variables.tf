# variable "id" {
#   description = "Secret key ID"
#   type        = string
# }

# variable "secret" {
#   description = "Secret key"
#   type        = string
# }

variable "s3_read_only" {
  description = "Secret key for S3 read user"
  type        = map
}

variable "s3_read_write" {
  description = "Secret key for S3 read write user"
  type        = map
}