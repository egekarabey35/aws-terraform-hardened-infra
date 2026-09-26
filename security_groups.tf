resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "ALB icin HTTP/HTTPS ingress ve sadece APP_SG egress"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    # CRITICAL FIX: ALB sadece App SG'ye (80 portu uzerinden) gidebilir
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  tags = { Name = "${var.environment}-alb-sg" }
}

resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "App servers sadece ALB'den kabul eder ve disariya sadece HTTPS(443) ile cikar"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    # CRITICAL FIX: Sadece DNF/Yum/AWS API guncellemeleri (HTTPS 443)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.environment}-app-sg" }
}
