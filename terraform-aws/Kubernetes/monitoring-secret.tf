resource "kubernetes_secret_v1" "grafana_smtp" {
  count = var.grafana_smtp_password != "" ? 1 : 0

  metadata {
    name      = "grafana-smtp"
    namespace = "monitoring"
  }

  type = "Opaque"

  data = {
    smtp-password = var.grafana_smtp_password
  }
}