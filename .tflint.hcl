plugin "aws" {
  enabled = true
  version = "0.29.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "aws_instance_invalid_ami" {
  enabled = true
}

rule "aws_security_group_invalid_ingress_cidr" {
  enabled = true
}
