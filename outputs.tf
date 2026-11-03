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
    compute_layer   = "Auto Scaling Group min_size=2 / desired_capacity=2, max_size=4 (t3.micro)"
    traffic_layer   = "ALB and NAT Gateway incur hourly and data processing charges"
    storage_layer   = "Encrypted gp3 volumes, at least two 8-GiB EBS roots"
    total_baseline  = "Estimate region- and usage-specific prices with AWS Pricing Calculator; not calculated by this output"
    finops_strategy = "The sample does not schedule scale-down; destroy ephemeral environments to avoid charges"
  }
}
