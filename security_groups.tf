resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "ALB HTTP/HTTPS ingress and restricted egress to App SG"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${var.environment}-alb-sg" }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "App servers accept from ALB and egress only HTTPS"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${var.environment}-app-sg" }
}

# Intentional public ingress for HTTP listener
#tfsec:ignore:aws-ec2-no-public-ingress-sgr:exp:2030-01-01
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  description       = "Allow public inbound HTTP traffic for redirection"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Intentional public ingress for HTTPS termination
#tfsec:ignore:aws-ec2-no-public-ingress-sgr:exp:2030-01-01
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  description       = "Allow public inbound HTTPS traffic"
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  description                  = "Forward traffic exclusively to private application nodes"
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  description                  = "Accept ingress exclusively from ALB security group"
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# Intentional egress for Linux repo updates and AWS API communication
#tfsec:ignore:aws-ec2-no-public-egress-sgr:exp:2030-01-01
resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  description       = "Allow outbound HTTPS for OS patching and AWS endpoints"
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
