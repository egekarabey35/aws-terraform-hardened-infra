# Hardened AWS Multi-Tier Cloud Infrastructure (IaC)

Bu proje, prodüksiyon standartlarında güvenli, yüksek erişilebilirlikli (Multi-AZ) ve sıkılaştırılmış bir AWS bulut altyapısının Terraform kullanılarak yönetilmesini sağlar.

## Mimari Genel Bakış
- Bolge: eu-central-1 (Frankfurt)
- Ag Izolasyonu: 2x Public Subnet, 2x Private Subnet (Multi-AZ)
- Dinamik CIDR hesaplamasi (cidrsubnet)
- Guvenlik (Least Privilege): ALB sadece 80/443 portlarina acik, App sunuculari sadece ALB uzerinden erisilebilir.
- FinOps: default_tags ile otomatik kaynak etiketleme.

## Kullanim
1. terraform init
2. terraform plan
3. terraform apply

