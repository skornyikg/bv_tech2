
aws_region = "eu-west-1"

//admin password of the backend RDS admin user
rds_admin_password = "bv123admin"

//CIDR block of the VPC
bv_network_cidr = "10.10.0.0/21"
//CIDR blocks of subnets to be created. public and private subnes
subnets_cidrs = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24"]


//key pairname for the EC2 instance
ec2_key_name = "bv-test-key"
//public key of the EC2 instance
//ec2_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgVgN/m79bOC26qz8q7/YBXC12ebxdNdCmlVHavop63MnF0FnClxDQTszxdPqZ1Q96QiegE3kZQP6v61q7fV+2Ow+OFgcBV1GXeOqWrqqwwMg0a5w/yVcRc9kaHmSXqSdxSTJnwn/vXItNktzlfNoO76jWwhKIodIxjKsCnKbGct8/+VTmlI9J5tNwOfhZuvPL+9u2pqpCiaU+xQZLueQ3hePn2CS8bUdLtq7SWqFhlUS+nvQDJs5AEl3PsPNimukGCax5KCzU1QV0wp+dKBuuGahJvRZC/3HjuIwGyOvqmu/Gwmw9huAafBrI0vOJwyEyztRrnEl0VF5ppZJ3eYa2w=="

//Route53 hosted zone id for the domain name
hosted_zone_id = "Z001445822WIZW6EVED6L"
// requested domain name inside the hosted zone
domain_name = "sg"

create_domain = true
