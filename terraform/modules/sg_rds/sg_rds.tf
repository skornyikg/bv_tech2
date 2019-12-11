resource "aws_security_group" "sg_rds" {
    name_prefix     = "${var.name_prefix}-${var.environment}"
    description     = "Security Group ${var.name_prefix}-${var.environment}"
    vpc_id          = var.vpc_id

    tags = {
      Name: "sg-${var.name_prefix}-${var.environment}-rds"
      Environment:  var.environment
    }

    // Enable traffic from the SG itself
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
    }

    // allow traffic for TCP 3306
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [var.security_group_id]
    }

    // outbound internet access
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
