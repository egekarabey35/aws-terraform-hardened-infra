# SIGN-OFF: Hardened AWS Multi-Tier Cloud Infrastructure
**Proje:** `aws-terraform-hardened-infra` (Portföy Projesi 1/5)
**İnceleme Kapsamı:** `compute.tf`, `security_groups.tf`, `vpc.tf`, `versions.tf`, `.tflint.hcl`, `.github/workflows/pipeline.yml`
**İnceleme Yöntemi:** Satır bazlı statik kod analizi, mimari bağımlılık (cycle) denetimi, IAM Least-Privilege doğrulaması ve CI/CD tedarik zinciri (SHA) güvenliği.

### Doğrulanmış Kontroller

| Kontrol Noktası | Dosya / Kaynak | Durum |
| :--- | :--- | :--- |
| **VPC Routing & NAT Gateway** | `vpc.tf` | ✅ Doğrulandı. Private subnet'ler izole edildi, 0.0.0.0/0 trafiği başarıyla NAT Gateway'e yönlendirildi. (Sonsuz ASG döngüsü engellendi). |
| **TLS Enforcement & Redirect** | `compute.tf` (ALB Listeners) | ✅ Doğrulandı. Port 80 HTTP 301 ile 443'e yönlendirildi. TLS 1.2+ politikası (`ELBSecurityPolicy-TLS13-1-2-2021-06`) zorunlu kılındı. |
| **KMS CMK & ASG Role Grants** | `compute.tf` (KMS Policy) | ✅ Doğrulandı. `AWSServiceRoleForAutoScaling` için gerekli `GenerateDataKey`, `Decrypt` ve `CreateGrant` izinleri Least-Privilege prensibiyle eklendi. |
| **EBS Encryption** | `compute.tf` (Launch Template) | ✅ Doğrulandı. Root volümler KMS CMK ile şifrelendi (`encrypted = true`). |
| **Zero-Trust Egress & Ingress** | `security_groups.tf` | ✅ Doğrulandı. SG Cycle (döngüsel bağımlılık) standalone kurallarla kırıldı. ALB sadece App SG'ye, App SG sadece HTTPS (443) ile dışarıya çıkabiliyor. |
| **Fail-Closed Security Scans** | `pipeline.yml` | ✅ Doğrulandı. `soft_fail: false` uygulandı. İzin verilen public mimari kararları, geçerlilik tarihi (exp) içeren `#tfsec:ignore` ile dokümante edildi. |
| **Supply-Chain Integrity** | `pipeline.yml` | ✅ Doğrulandı. Tüm GitHub Action'ları immutable SHA commit hash'lerine sabitlendi. |
| **IaC State Locking** | `.terraform.lock.hcl` | ✅ Doğrulandı. Multi-platform (Linux/Darwin) kilit dosyası üretildi, `init -lockfile=readonly` güvencesi sağlandı. |

### Kabul Edilen Kalıntı Riskler (Known Limitations)
*Mülakatlarda bilinçli mimari trade-off (ödünleşim) olarak savunulacak maddeler:*
*   **Self-Signed ACM Certificate:** Gerçek bir domain olmaması sebebiyle `tls_self_signed_cert` kullanılmıştır. Tarayıcı tarafında güven zinciri hatası verecektir, ancak transit şifreleme (in-transit encryption) tam olarak çalışmaktadır.
*   **Single-AZ NAT Gateway:** Yüksek erişilebilirlik (HA) yerine AWS maliyet optimizasyonu (FinOps) gözetilerek tek bir AZ'de NAT Gateway konumlandırılmıştır.
*   **Local State Management:** Demo portföyü olması sebebiyle S3+DynamoDB remote state backend kurgulanmamıştır.
*   **VPC Flow Logs Disabled:** CloudWatch veri maliyetlerini önlemek amacıyla devre dışı bırakılmıştır.

**Nihai Değerlendirme:**
Bu altyapı kodu; ağ izolasyonunu, kriptografik veri güvenliğini, kimlik erişim yönetimini (IAM) ve CI/CD zırhlamasını eksiksiz bir şekilde uygulamaktadır. Tespit edilen tüm güvenlik açıkları ve mimari hatalar (fail-open, NAT routing, SG cycle, KMS grants) başarıyla onarılmıştır. Proje, Staff/Principal seviyesi mülakatlarda satır satır savunulabilir durumdadır. **ONAYLANDI.**
