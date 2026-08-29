resource "kubernetes_manifest" "my_python_app" {
  depends_on = [
    helm_release.argocd
  ]

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "my-python-app"
      namespace = "argocd"
    }

    spec = {
      project = "default"

      source = {
        repoURL        = "https://github.com/nanda9/flask-python-app.git"
        targetRevision = "main"
        path           = "flask-chart"
      }

      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "dev"
      }

      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }

        syncOptions = [
          "CreateNamespace=true"
        ]
      }
    }
  }
}