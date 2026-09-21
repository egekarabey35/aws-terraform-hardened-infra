variable "aws_region" {
  description = "AWS kaynaklarinin dagitilacagi bolge"
  type        = string
  default     = "eu-central-1" # Frankfurt (dusuk gecikme)
}

variable "environment" {
  description = "Calisma ortami (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC ana IP araligi"
  type        = string
  default     = "10.0.0.0/16"
}
