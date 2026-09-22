output "vpc_id" {
  description = "Olusturulan VPC kimligi"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public Subnet kimlikleri"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "Private Subnet kimlikleri"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "alb_security_group_id" {
  description = "ALB Guvenlik Grubu kimligi"
  value       = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  description = "Application Load Balancer genel erisim DNS adresi"
  value       = aws_lb.main.dns_name
}

output "finops_cost_analysis" {
  description = "Estimated monthly baseline cost for this hardened infrastructure"
  value = {
    compute_layer   = "2x t3.micro instances (Eligible for AWS Free Tier or ~$7.50/mo each)"
    traffic_layer   = "1x Application Load Balancer (~$16.20/mo + LCU usage)"
    storage_layer   = "Standard EBS gp3 root volumes (~$0.08/GB-month)"
    total_baseline  = "Estimated ~$31 - $35/month baseline (Excluding Free Tier discounts)"
    finops_strategy = "ASG scales down to min_size=1 off-hours to eliminate 50% compute waste"
  }
}

output "finops_cost_analysis" {
  description = "Estimated monthly baseline cost for this hardened infrastructure"
  value = {
    compute_layer   = "2x t3.micro instances (Eligible for AWS Free Tier or ~$7.50/mo each)"
    traffic_layer   = "1x Application Load Balancer (~$16.20/mo + LCU usage)"
    storage_layer   = "Standard EBS gp3 root volumes (~$0.08/GB-month)"
    total_baseline  = "Estimated ~$31 - $35/month baseline (Excluding Free Tier discounts)"
    finops_strategy = "ASG scales down to min_size=1 off-hours to eliminate 50% compute waste"
  }
}


application_cost = {
  compute_layer   = "2x t3.micro instances (Eligible for AWS Free Tier or ~$7.50/mo each)"
  traffic_layer   = "1x Application Load Balancer (~$16.20/mo + LCU usage)"
  storage_layer   = "Standard EBS gp3 root volumes (~$0.08/GB-month)"
  total_baseline  = "Estimated ~$31 - $35/month baseline (Excluding Free Tier discounts)"
  finops_strategy = "ASG scales down to min_size=1 off-hours to eliminate 50% compute waste"
}

output "finops_cost_analysis" {
  description = "Estimated monthly baseline cost for this hardened infrastructure"
  value       = local.application_cost
}
