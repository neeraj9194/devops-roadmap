variable "region" {
    type = string
    default = "ap-south-1"
}

variable "availability_zones_count" {
    # considering only 2 because, ap-south 3rd zone does not support t2.micro (other's might). 
    # I can create data source to choose from a list like t3.micro but it may not be included in free tier.
    default = 2
}

