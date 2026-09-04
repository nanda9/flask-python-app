resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "monitoring" {
  name      = "monitoring"
  namespace = kubernetes_namespace_v1.monitoring.metadata[0].name

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  create_namespace = false

  values = [
    file("${path.module}/../../monitoring/monitoring-values.yaml")
  ]

  set = [
    {
      name  = "grafana.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = data.terraform_remote_state.aws.outputs.grafana_cloudwatch_role_arn
    }
  ]

  depends_on = [
    kubernetes_namespace_v1.monitoring,
    kubernetes_secret_v1.grafana_smtp
  ]
}