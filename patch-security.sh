#!/bin/bash
echo "[*] AWS Hardening yamasi baslatiliyor..."

# 1. KMS Rotasyonunu zorunlu kil
find . -name "*.tf" -type f -exec sed -i.bak '/resource "aws_kms_key"/a\  enable_key_rotation = true' {} +

# 2. Capital One SSRF Korumasi (IMDSv2 Zorunlulugu)
find . -name "*.tf" -type f -exec sed -i.bak '/resource "aws_launch_template"/a\  metadata_options {\n    http_endpoint               = "enabled"\n    http_tokens                 = "required"\n    http_put_response_hop_limit = 1\n  }' {} +

# 3. EKS Public Endpoint'i Kapat (Zero-Trust)
find . -name "*.tf" -type f -exec sed -i.bak 's/endpoint_public_access.*=.*true/endpoint_public_access = false/g' {} +

# Yedek dosyalari (bak) temizle
find . -name "*.tf.bak" -type f -delete

echo "[+] Guvenlik yamalari basariyla uygulandi!"
