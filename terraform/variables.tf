variable aws_region {
  description = "default AWS region"
  default = "us-east-1"
}

variable "bv_network_cidr" {
  description = "CIDR block of the VPC"
  default     = "10.10.0.0/21"
}

variable "subnets_cidrs" {
  description = "CIDR blocks of subnets to be created. public and private subnes"
}

variable "ec2_key_name" {
  description = "key pairname for the EC2 instance"
  default     = "bv_test_key"
}

variable "ec2_public_key" {
  description = "public key of the EC2 instance"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgVgN/m79bOC26qz8q7/YBXC12ebxdNdCmlVHavop63MnF0FnClxDQTszxdPqZ1Q96QiegE3kZQP6v61q7fV+2Ow+OFgcBV1GXeOqWrqqwwMg0a5w/yVcRc9kaHmSXqSdxSTJnwn/vXItNktzlfNoO76jWwhKIodIxjKsCnKbGct8/+VTmlI9J5tNwOfhZuvPL+9u2pqpCiaU+xQZLueQ3hePn2CS8bUdLtq7SWqFhlUS+nvQDJs5AEl3PsPNimukGCax5KCzU1QV0wp+dKBuuGahJvRZC/3HjuIwGyOvqmu/Gwmw9huAafBrI0vOJwyEyztRrnEl0VF5ppZJ3eYa2w=="
}

variable rds_admin_password {
  description = "admin password of the backend RDS admin user"
}

variable "environment" {
  default = "test"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_instance_count" {
  default = 1
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone id for the domain name"
}

variable "domain_name" {
  description = "requested domain name inside the hosted zone"
}

variable "create_domain" {
  default = true
}

