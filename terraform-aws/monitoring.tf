resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  create_namespace = true

  values = [
    file("${path.module}/../monitoring/monitoring-values.yaml")
  ]
}