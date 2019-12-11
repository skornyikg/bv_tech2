resource "aws_security_group" "sg_ssh" {
    name_prefix     = "${var.name_prefix}-${var.environment}"
    description     = "Security Group ${var.name_prefix}-${var.environment}"
    vpc_id          = var.vpc_id

    tags = {
      Name: "sg-${var.name_prefix}-${var.environment}"
      Environment:  var.environment
    }
    // allows traffic from the SG itself
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
    }

    // allow traffic for TCP 22
    ingress {
        from_port   = 22
        to_port     = 22
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
