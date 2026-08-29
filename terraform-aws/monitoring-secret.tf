resource "kubernetes_secret_v1" "grafana_smtp" {
  metadata {
    name      = "grafana-smtp"
    namespace = "monitoring"
  }

  type = "Opaque"

  data = {
    smtp-password = var.grafana_smtp_password
  }
}