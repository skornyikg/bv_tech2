// Module specific variables
variable "name_prefix" {
	default = "sg_elb"
}

variable "environment" {
  default = "test"
}

variable "vpc_id" {
  description = "VPC id of the security group"
}

variable "source_cidr_block" {
  description = "source CIDR block to allow traffic from"
  default = "0.0.0.0/0"
}