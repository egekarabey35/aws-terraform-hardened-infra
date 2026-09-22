output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
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
