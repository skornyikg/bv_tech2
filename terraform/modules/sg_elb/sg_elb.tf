resource "aws_security_group" "sg_elb" {
    name_prefix   = "${var.name_prefix}-${var.environment}"
    description   = "Security Group ${var.name_prefix}-${var.environment}"
    vpc_id        = var.vpc_id

    tags = {
      Name: "sg-${var.name_prefix}-${var.environment}"
      Environment:  var.environment
    }
  # Enable HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.source_cidr_block}"]
  }

  // Enable HTTPS access
  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.source_cidr_block]
  }

  # Enable outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.source_cidr_block]
  }
}