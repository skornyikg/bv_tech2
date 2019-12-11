
aws_region = "eu-west-1"

//destination VPC id
bv_vpc_id = "vpc-0131911f558a0d59d"
//CIDR block of the VPC
bv_network_cidr = "10.10.0.0/21"
//CIDR blocks of subnets to be created. public and private subnes
subnets_cidrs = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24"]

//key pairname for the EC2 instance
ec2_key_name = "bv-test-key"
//public key of the EC2 instance
//ec2_public_key = "ssh-rsa AAAAB"

//admin password of the backend RDS admin user
rds_admin_password = "bv123admin"

//Route53 hosted zone id for the domain name
hosted_zone_id = "Z001445822WIZW6EVED6L"
// requested domain name inside the hosted zone
domain_name = "sg"

create_domain = true
create_igw = false
