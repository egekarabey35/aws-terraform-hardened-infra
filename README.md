# Hardened AWS Multi-Tier Cloud Infrastructure (IaC & DevSecOps)

[![DevSecOps - IaC Security & Quality Pipeline](https://github.com/egekarabey35/aws-terraform-hardened-infra/actions/workflows/security-scan.yml/badge.svg)](https://github.com/egekarabey35/aws-terraform-hardened-infra/actions/workflows/security-scan.yml)
!e[Terraform](https://img.shields.io/badge/Terraform-1.9.5-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud%20Security-232F3E?logo=amazon-web-services&logoColor=white)
![Security Scanned](https://img.shields.io/badge/Security%20Scan-TFSec%20%7C%20TFLint-brightgreen)

Production-grade, highly available, and security-hardened AWS infrastructure deployed via Terraform. Built following the **AWS Well-Architected Framework (Security & Cost Optimization Pillars)** and DevSecOps principles.

---

## Architecture Overview

* **VPC Layer:** Multi-AZ 2 Public and 2 Private Subnets with strictly separated routing tables.
* **Compute Layer:** Auto Scaling Group (ASG) deployed exclusively in Private Subnets.
* **Ingress Layer:** Internet-facing Application Load Balancer (ALB) acting as the single entry point.

---

## Security Hardening & DevSecOps Implementation

* **Zero-Trust Network Isolation:** Compute instances reside purely within private subnets with no public IPs assigned. All inbound access is routed exclusively through the ALB.
* **IMDSv2 Enforcement:** Launch Templates mandate `http_tokens = "required"` and hop limit `1`, mitigating Server-Side Request Forgery (SSRF) risks from stealing instance metadata/credentials.
* **Least-Privilege Security Groups:** Application security groups accept traffic solely from the ALB security groupID, preventing lateral network movement.
* **Automated CI/CD Quality & Security Gates:** Every push and pull request runs automated syntax formatting (`terraform fmt`), linting (`tflint`), and static code security scanning (`tfsec`).

---

## FinOps & Cost Engineering

* **Resource Sizing:** Leveraged cost-effective `t3.micro` burstable compute nodes.
+ **Auto-Scaling Strategy:** Desired capacity configured with dynamic scaling bounds (2 to 4 instances) with scale-in policies to eliminate idle capacity expenses.
** **Estimated Baseline:** ~$31.00/month (Free Tier eligible).

---

## Deployment

```bash
terraform init
terraform plan
terraform apply
```
