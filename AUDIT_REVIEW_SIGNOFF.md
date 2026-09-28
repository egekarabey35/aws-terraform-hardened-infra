# SIGN-OFF: AWS Terraform Hardened Infrastructure
**Proje:** `aws-terraform-hardened-infra` (Portföy Projesi 1/5)
**İnceleme Kapsamı:** VPC Ağ İzolasyonu, IAM Least-Privilege, EC2 Metadata Security (IMDSv2), KMS Şifreleme (Encryption in Transit/Rest) ve State Koruması (DynamoDB/S3).
**İnceleme Yöntemi:** Terraform konfigürasyonlarının SOC2 ve PCI-DSS uyumluluk standartlarına göre statik analizi ve manuel X-Ray denetimi.

### Doğrulanmış Kontroller

| Kontrol Noktası | Dosya / Kaynak | Durum |
| :--- | :--- | :--- |
| **SSRF / Capital One Koruması** | `compute.tf` | ✅ Doğrulandı. Tüm EC2 Launch Template'lerinde Metadata Servisi (IMDSv2) zorunlu kılınmış (`http_tokens = "required"`). Yetki (token) sızıntıları donanımsal düzeyde engellenmiştir. |
| **Kriptografik Rotasyon** | `compute.tf` | ✅ Doğrulandı. Müşteri yönetimindeki KMS anahtarlarında (CMK) yıllık otomatik rotasyon (`enable_key_rotation = true`) aktiftir. |
| **State Güvenliği ve Kilit** | `backend` yapısı | ✅ Doğrulandı. Terraform state dosyaları merkezi bir S3 bucket'ta tutulmakta ve eşzamanlı yarış (race condition) senaryolarına karşı DynamoDB ile atomik olarak kilitlenmektedir. |
| **Ağ İzolasyonu (Zero-Trust)** | VPC Yapılandırması | ✅ Doğrulandı. Kritik veri tabanları ve compute kaynakları dışarıya kapalı private subnet'lerde izole edilmiş, NAT Gateway ile denetimli çıkış kurgulanmıştır. |

**Nihai Değerlendirme:**
Bu altyapı, "Güvenlik Sonradan Eklenmez, Tasarımdan Gelir" (Security-by-Design) prensibiyle yazılmıştır. Mülakatlarda sıkça sorulan "Capital One nasıl hacklendi ve sen bunu Terraform'da nasıl önlersin?" sorusuna IMDSv2 yamasıyla cevap verebilen, şifreleme rotasyonlarını açık bırakmayan endüstri standardı bir projedir. **ONAYLANDI.**
