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

#tfsec:ignore:aws-ec2-no-public-ingress-sgr:exp: ALB is intentionally public-facing
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr:exp: ALB is intentionally public-facing
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr:exp: App nodes need HTTPS access to AWS APIs and Yum repos
resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
