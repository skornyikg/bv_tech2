variable "name" {
  default = "bv_wordpress"
}

variable "environment" {
  default = "test"
}
variable "bv_network_cidr" {
  description = "VPV base CIDR"
}

variable "subnets_cidrs" {
  description = "Array of cidr blocks for all subnets"
}

variable "num_of_public_subnets" {
  default = "2"
}

variable "num_of_private_subnets" {
  default = "2"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default = true
}
variable "enable_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default = true
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
  default = false
}

data "aws_availability_zones" "available" {
  state = "available"
}

