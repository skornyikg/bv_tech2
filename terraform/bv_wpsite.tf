/*
TODO 
*/

provider "aws" {
  region      = var.aws_region
  #access_key = ""
  #secret_key = ""
}

terraform {
  backend "s3" {
    bucket    = "sg-bv-test"
    key       = "terraform.tfstate"
    region    = "eu-west-1"
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

data "external" "hostname" {
  program     = ["sh", "hostname.sh"]
}

module "bv_network" {
  source                  = "./modules/bv_network"
  name                    = "bv_wordpress"
  environment             = "test"
  
  create_igw              = var.create_igw

  bv_vpc_id               = var.bv_vpc_id
  bv_network_cidr         = var.bv_network_cidr
  map_public_ip_on_launch = true
  #subnets_cidrs           = cidrsubnets("10.10.0.0/21", 4, 4, 4, 4)
  subnets_cidrs           = var.subnets_cidrs
}

module "sg_ssh" {
  source            = "./modules/sg_ssh"
  name_prefix       = "ssh"
  environment       = "test"
  vpc_id            = var.bv_vpc_id
  source_cidr_block = "${data.external.hostname.result["ip"]}/32"
}

module "sg_web" {
  source            = "./modules/sg_web"
  name_prefix       = "web"
  environment       = "test"
  vpc_id            = var.bv_vpc_id
  source_cidr_block = "${data.external.hostname.result["ip"]}/32"
}

module "sg_elb" {
  source            = "./modules/sg_elb"
  name_prefix       = "elb"
  environment       = "test"
  vpc_id            = var.bv_vpc_id
  source_cidr_block = "${data.external.hostname.result["ip"]}/32"
}

module "sg_rds" {
  source            = "./modules/sg_rds"
  name_prefix       = "rds"
  environment       = "test"
  vpc_id            = var.bv_vpc_id
  security_group_id = module.sg_web.sg_web_id
}


module "alb" {
  source              = "terraform-aws-modules/alb/aws"
  version             = "~> 5.0"
  name                = "alb-test"
  load_balancer_type  = "application"

  vpc_id              = var.bv_vpc_id
  subnets             = module.bv_network.public_subnet_ids
  security_groups     = [module.sg_elb.sg_elb_id]

  target_groups = [
    {
      name_prefix     = "http"
      backend_protocol= "HTTP"
      backend_port    = 80
      target_type     = "instance"
    }
  ]

  https_listeners = []
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment: "Test"
  }
}

/*
resource "aws_key_pair" "ec2key" {
  key_name    = var.ec2_key_name 
  public_key  = var.ec2_public_key
}
*/

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "wp-db-${var.environment}-subnet-group"
  subnet_ids  = module.bv_network.private_subnet_ids_str
}

resource "aws_db_instance" "rds" {
  identifier              = "wp-db-${var.environment}"
  allocated_storage       = 5
  engine                  = "mysql"
  engine_version          = "5.7.26"
  instance_class          = "db.t2.micro"
  multi_az                = "false"
  name                    = "bv_wp_db"
  username                = "admin"
  password                = var.rds_admin_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids  = [module.sg_rds.sg_rds_id]
  skip_final_snapshot     = false
  
  tags = {
    Environment: var.environment
  }
}

resource "aws_instance" "wp_server" {
  ami                         = data.aws_ami.amazon-linux-2.id
  vpc_security_group_ids      = [module.sg_ssh.sg_ssh_id, module.sg_web.sg_web_id]
  #key_name                    = aws_key_pair.ec2key.key_name
  key_name                    = var.ec2_key_name
  instance_type               = var.ec2_instance_type
  associate_public_ip_address = true
  count                       = var.ec2_instance_count
  subnet_id                   = element(module.bv_network.public_subnet_ids, count.index%2)
  root_block_device {
        volume_type           = "gp2"
        volume_size           = 20
        delete_on_termination = "true"
  }
  tags = {
    Name: "WP-SERVER-${var.environment}-${format("%02d", count.index+1)}"
    Environment: var.environment
  }
  user_data = ""
}

resource "aws_alb_target_group_attachment" "tg_bv_wp" {
  target_group_arn       = module.alb.target_group_arns[0]
  target_id              = aws_instance.wp_server[0].id
  port                   = 80
}


resource "aws_route53_record" "wp_server_domain" {

  count = var.create_domain ? 1 : 0

  zone_id     = var.hosted_zone_id
  name        = var.domain_name
  type        = "A"

  alias {
    name    = module.alb.this_lb_dns_name
    zone_id = module.alb.this_lb_zone_id
    evaluate_target_health = false
  }
}

