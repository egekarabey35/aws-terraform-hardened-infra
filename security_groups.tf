# 1. Application Load Balancer Güvenlik Grubu (Halka Açık Ön Yüz)
resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "ALB icin sadece HTTP ve HTTPS girisine izin veren guvenlik grubu"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP erisimi"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS erisimi"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Tum disari cikis trafigine izin ver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

# 2. Uygulama Katmanı Güvenlik Grubu (Private Alanda Yaşar)
resource "aws_security_group" "app_sg" {
  name        = "${var.environment}-app-sg"
  description = "Uygulama sunuculari sadece ALB uzerinden trafik kabul eder"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Sadece ALB Guvenlik Grubundan gelen web trafigi"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Paket guncellemeleri icin disari cikis"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
  }
}
