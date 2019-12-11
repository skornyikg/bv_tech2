resource "aws_security_group" "sg_web" {
    name_prefix     = "${var.name_prefix}-${var.environment}"
    description     = "Security Group ${var.name_prefix}-${var.environment}"
    vpc_id          = var.vpc_id

    tags = {
      Name: "sg-${var.name_prefix}-${var.environment}"
      environment: var.environment
    }
    // allows traffic from the SG itself
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
    }

    // allow traffic for TCP 80
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.source_cidr_block]
    }

    // allow traffic for TCP 443
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [var.source_cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  
}