# Flask Python Application — Production-Grade DevOps on AWS EKS

A production-oriented Flask application deployed on **Amazon EKS** using **Docker, Amazon ECR, Kubernetes, Helm, GitHub Actions, and Argo CD**, with centralized monitoring and observability using **Prometheus, Grafana, Alertmanager, and Loki**.

The project demonstrates an end-to-end DevOps workflow from source code commit through containerization, CI/CD, Kubernetes deployment, AWS load balancing, and application observability.

---

## Architecture

### Application Delivery

```text
                         Developer
                            |
                            v
                       GitHub Repository
                            |
                            v
                    GitHub Actions CI
                            |
                 +----------+----------+
                 |                     |
                 v                     v
             Build/Test          Docker Image
                                      |
                                      v
                                Amazon ECR
                                      |
                                      v
                                  Argo CD
                                      |
                                      v
                                   Helm
                                      |
                                      v
                                Amazon EKS
                                      |
                              +-------+-------+
                              |               |
                              v               v
                         Flask Pods       Kubernetes
                              |             Services
                              |               |
                              +-------+-------+
                                      |
                                      v
                              AWS Load Balancer
                                    (ALB)
                                      |
                                      v
                                   Users
```

### Observability

```text
                         Flask Application
                                |
                                | /metrics
                                v
                         ServiceMonitor
                                |
                                v
                            Prometheus
                           /          \
                          /            \
                         v              v
                    Grafana         Alertmanager
                       |
                       |
                       v
                      Loki
                       |
                       v
                    Grafana
```

---

# Technology Stack

| Area               | Technology                    |
| ------------------ | ----------------------------- |
| Application        | Python / Flask                |
| Containerization   | Docker                        |
| Container Registry | Amazon ECR                    |
| Kubernetes         | Amazon EKS                    |
| Package Management | Helm                          |
| CI                 | GitHub Actions                |
| CD / GitOps        | Argo CD                       |
| Load Balancing     | AWS Application Load Balancer |
| Monitoring         | Prometheus                    |
| Visualization      | Grafana                       |
| Alerting           | Alertmanager                  |
| Logging            | Loki                          |
| Metrics Export     | `prometheus-client`           |
| Application Server | Flask                         |
| Kubernetes API     | Kubernetes Python client      |

---

# Project Structure

```text
flask-python-app/
│
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
├── .gitignore
│
├── flask-chart/
│   ├── Chart.yaml
│   ├── values.yaml
│   │
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── ingress.yaml
│       ├── hpa.yaml
│       ├── pdb.yaml
│       ├── serviceaccount.yaml
│       ├── flask-rbac.yaml
│       ├── configmap.yaml
│       ├── secret.yaml
│       ├── servicemonitor.yaml
│       └── prometheusrule.yaml
│
├── GitOps-Repo/
│   └── argocd-app.yaml
│
├── monitoring/
│   ├── monitoring-values.yaml
│   ├── prometheus-values.yaml
│   ├── loki-values.yaml
│   ├── servicemonitor.yaml
│   └── prometheus-rules.yaml
│
├── kubernetes-backup/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── hpa.yaml
│
├── static/
│
└── templates/
    └── index.html
```

---

# Application

The application is built with Flask and exposes three primary endpoints.

## Application Endpoint

```text
GET /
```

The application displays environment information and queries the Kubernetes API to determine the number of running application pods.

The application uses environment variables such as:

```text
APP_NAME
APP_ENV
COMPANY
NAMESPACE
```

---

## Health Endpoint

```text
GET /health
```

Used by Kubernetes for health checks.

Example response:

```json
{
  "status": "healthy"
}
```

Kubernetes uses this endpoint for:

* Startup probe
* Readiness probe
* Liveness probe

---

## Metrics Endpoint

```text
GET /metrics
```

The Flask application exposes Prometheus metrics using the Python Prometheus client.

Current application metrics include:

```text
flask_requests_total
flask_request_duration_seconds
```

These metrics allow Prometheus to monitor application traffic and request latency.

---

# Docker

The application is containerized using Docker.

The container provides a consistent runtime environment for the Flask application.

The Docker image is pushed to **Amazon ECR**, which acts as the container registry used by the EKS deployment.

Basic workflow:

```bash
docker build -t flask-python-app .
```

Tag the image for ECR:

```bash
docker tag flask-python-app:latest \
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:<TAG>
```

Push the image:

```bash
docker push \
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:<TAG>
```

---

# Amazon ECR

Amazon ECR stores the Docker images used by the Kubernetes deployment.

The Helm values configure the application image:

```yaml
image:
  repository: 405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
  pullPolicy: Always
  tag: <IMAGE_TAG>
```

The image tag can represent a Git commit SHA, allowing the deployment to be associated with a specific version of the source code.

---

# Amazon EKS

The application runs inside an Amazon EKS cluster.

Kubernetes provides:

* Container orchestration
* Pod scheduling
* Service discovery
* Rolling deployments
* Health checks
* Horizontal scaling
* RBAC
* Self-healing

The application is deployed into the:

```text
dev
```

namespace.

---

# Helm

The Flask application is packaged as a Helm chart.

The chart contains Kubernetes resources including:

```text
Deployment
Service
Ingress
HPA
PodDisruptionBudget
ServiceAccount
RBAC
ConfigMap
Secret
ServiceMonitor
PrometheusRule
```

Helm values control environment-specific configuration.

Example:

```yaml
replicaCount: 5

image:
  repository: 405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
  tag: <IMAGE_TAG>

service:
  type: NodePort
  port: 80
  targetPort: 5000

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
```

---

# Kubernetes Deployment

The Flask application is deployed using a Kubernetes Deployment.

The deployment uses a rolling update strategy:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

This allows new pods to become available before existing pods are terminated.

The application also uses:

* Startup probe
* Readiness probe
* Liveness probe
* Resource requests
* Resource limits
* PodDisruptionBudget

---

# Kubernetes Health Checks

The application exposes:

```text
/health
```

Kubernetes uses this endpoint for:

### Startup Probe

Determines whether the application has successfully started.

### Readiness Probe

Determines whether the pod is ready to receive traffic.

### Liveness Probe

Determines whether the application is still functioning.

This prevents Kubernetes from routing traffic to unhealthy application instances.

---

# Horizontal Pod Autoscaler

The Helm chart supports Kubernetes HPA.

Current configuration:

```yaml
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
```

The HPA can scale the application between:

```text
3 → 10 replicas
```

based on CPU utilization.

---

# AWS Application Load Balancer

The Kubernetes Ingress is configured to use the AWS Load Balancer Controller.

The architecture is:

```text
Internet
   |
   v
AWS Application Load Balancer
   |
   v
Kubernetes Service
   |
   v
Flask Pods
```

The Ingress uses:

```yaml
ingress:
  enabled: true
  className: alb
```

The ALB is configured as an internet-facing load balancer and uses IP targets.

---

# RBAC

The Flask application interacts with the Kubernetes API to retrieve pod information.

The application therefore uses a Kubernetes ServiceAccount with RBAC permissions.

The ServiceAccount is:

```text
flask-sa
```

The application is granted the minimum Kubernetes permissions required to read pod information.

The application uses the Kubernetes Python client:

```python
from kubernetes import client, config
```

Inside Kubernetes it loads:

```python
config.load_incluster_config()
```

This allows the Flask application to communicate with the Kubernetes API using its ServiceAccount identity.

---

# GitHub Actions

GitHub Actions provides the CI workflow.

The CI pipeline is responsible for automating application validation and container image creation.

The intended workflow is:

```text
Git Push
   |
   v
GitHub Actions
   |
   +--> Checkout source
   |
   +--> Install dependencies
   |
   +--> Run tests
   |
   +--> Build Docker image
   |
   +--> Push image to Amazon ECR
   |
   v
New container image
```

The container image is stored in Amazon ECR and becomes available for deployment to EKS.

---

# Argo CD

Argo CD provides continuous delivery using the GitOps model.

The Argo CD Application is configured to watch this repository:

```text
https://github.com/nanda9/flask-python-app.git
```

and deploy the Helm chart:

```text
flask-chart
```

into:

```text
dev
```

namespace.

Argo CD configuration:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

### Automated Sync

Argo CD automatically synchronizes the Kubernetes cluster with the desired state stored in Git.

### Self-Healing

If a Kubernetes resource is manually changed, Argo CD can restore it to the Git-defined state.

### Pruning

Resources removed from Git can be removed from the Kubernetes cluster.

---

# GitOps Deployment Flow

The complete deployment flow is:

```text
Developer
   |
   v
Git Commit
   |
   v
GitHub
   |
   v
GitHub Actions
   |
   v
Docker Image
   |
   v
Amazon ECR
   |
   v
Git / Helm configuration
   |
   v
Argo CD
   |
   v
Amazon EKS
   |
   v
Flask Deployment
```

This separates:

```text
CI  = GitHub Actions

CD  = Argo CD
```

GitHub Actions builds and validates the application.

Argo CD continuously reconciles the Kubernetes environment with the desired state stored in Git.

---

# Prometheus Monitoring

Prometheus monitors the Kubernetes cluster and Flask application.

The Flask application exposes:

```text
/metrics
```

A Kubernetes `ServiceMonitor` configures Prometheus to scrape the application.

Example:

```yaml
spec:
  endpoints:
    - port: http
      path: /metrics
      interval: 15s
```

The ServiceMonitor selects the Flask service using Kubernetes labels.

---

# Application Availability Monitoring

Prometheus provides the `up` metric for scrape targets.

For example:

```promql
up{
  job="my-python-app-flask-chart",
  namespace="dev"
}
```

A value of:

```text
1
```

means the target is currently reachable.

A value of:

```text
0
```

means Prometheus cannot successfully scrape the target.

For the application:

```promql
sum(
  up{
    job="my-python-app-flask-chart",
    namespace="dev"
  }
)
```

can be used to determine the number of healthy Prometheus scrape targets.

---

# PrometheusRule

Application alerts are defined using Kubernetes `PrometheusRule` resources.

The Helm chart generates:

```text
my-python-app-flask-chart-alerts
```

The alerting layer can monitor Kubernetes deployment availability.

Example:

```promql
kube_deployment_status_replicas_available{
  namespace="dev",
  deployment="my-python-app-flask-chart"
} < 1
```

This detects when the application has no available replicas.

The alert can then be routed through Alertmanager.

---

# Alertmanager

Alertmanager handles alerts generated by Prometheus.

The monitoring architecture is:

```text
Prometheus
    |
    | Alert
    v
Alertmanager
    |
    +--> Group
    +--> Deduplicate
    +--> Route
    +--> Notify
```

This separates metric collection from alert routing and notification management.

---

# Grafana

Grafana provides visualization for the monitoring platform.

Prometheus is configured as a Grafana data source.

Grafana dashboards can visualize:

* Application availability
* Request rate
* Request latency
* Pod count
* CPU utilization
* Memory utilization
* Deployment replicas
* HPA activity
* Kubernetes resource health

Example PromQL queries:

### Application Availability

```promql
sum(
  up{
    job="my-python-app-flask-chart",
    namespace="dev"
  }
)
```

### Request Rate

```promql
rate(
  flask_requests_total[5m]
)
```

### Request Latency

```promql
rate(
  flask_request_duration_seconds_sum[5m]
)
/
rate(
  flask_request_duration_seconds_count[5m]
)
```

---

# Loki

Loki provides centralized log storage for the observability stack.

The goal is to provide a single Grafana interface for:

```text
Metrics + Logs + Alerts
```

Conceptually:

```text
Prometheus → Metrics
Loki       → Logs
Alertmanager → Alerts
Grafana    → Visualization
```

This allows application and Kubernetes operational data to be investigated from one observability platform.

---

# Monitoring Architecture

```text
                         +----------------+
                         | Flask App      |
                         |                |
                         | /metrics       |
                         +-------+--------+
                                 |
                                 v
                         +---------------+
                         | ServiceMonitor|
                         +-------+-------+
                                 |
                                 v
                         +---------------+
                         | Prometheus    |
                         +---+-------+---+
                             |       |
                 Metrics     |       | Alerts
                             |       v
                             |  +-----------+
                             |  |Alertmanager|
                             |  +-----------+
                             |
                             v
                         +---------+
                         | Grafana |
                         +----+----+
                              |
                              v
                           +------+
                           | Loki |
                           +------+
```

---

# Useful Kubernetes Commands

### Check application pods

```bash
kubectl get pods -n dev
```

### Check services

```bash
kubectl get svc -n dev
```

### Check ingress

```bash
kubectl get ingress -n dev
```

### Check deployment

```bash
kubectl get deployment -n dev
```

### Check HPA

```bash
kubectl get hpa -n dev
```

### Check ServiceMonitor

```bash
kubectl get servicemonitor -n dev
```

### Check PrometheusRule

```bash
kubectl get prometheusrule -n dev
```

### Check Argo CD application

```bash
kubectl get application my-python-app -n argocd
```

### Check Argo CD synchronization

```bash
kubectl get application my-python-app -n argocd \
-o wide
```

---

# Helm Validation

Before committing Helm changes:

```bash
helm lint ./flask-chart
```

Render the complete Kubernetes configuration:

```bash
helm template my-python-app ./flask-chart
```

Validate the rendered manifests:

```bash
helm template my-python-app ./flask-chart > /tmp/flask-rendered.yaml
```

Then:

```bash
kubectl apply \
  --dry-run=client \
  -f /tmp/flask-rendered.yaml
```

This verifies that Helm is producing valid Kubernetes resources before they are synchronized by Argo CD.

---

# Deployment Verification

After Argo CD synchronization:

```bash
kubectl get application my-python-app -n argocd
```

Expected:

```text
SYNC STATUS     HEALTH STATUS
Synced          Healthy
```

Then verify:

```bash
kubectl get pods -n dev
kubectl get svc -n dev
kubectl get ingress -n dev
kubectl get hpa -n dev
kubectl get servicemonitor -n dev
kubectl get prometheusrule -n dev
```

---

# Key DevOps Concepts Demonstrated

This project demonstrates practical experience with:

### Containerization

* Docker
* Container image lifecycle
* Amazon ECR

### Kubernetes

* Deployments
* Services
* Ingress
* HPA
* PDB
* Probes
* ConfigMaps
* Secrets
* ServiceAccounts
* RBAC

### AWS

* Amazon EKS
* Amazon ECR
* AWS Application Load Balancer
* AWS Load Balancer Controller
* IAM / OIDC integration

### CI/CD

* GitHub Actions
* Argo CD
* GitOps
* Automated synchronization
* Self-healing deployments

### Observability

* Prometheus
* ServiceMonitor
* PrometheusRule
* Alertmanager
* Grafana
* Loki
* Application metrics

---

# Production Engineering Practices

The project incorporates several production-oriented practices:

* Immutable container images
* Git-based deployment configuration
* Helm-based Kubernetes configuration
* Rolling updates
* Readiness and liveness checks
* Startup probes
* Resource requests and limits
* Horizontal pod autoscaling
* Pod disruption protection
* Kubernetes RBAC
* Application metrics
* Prometheus-based monitoring
* Alertmanager-based alerting
* Centralized logging
* GitOps-based continuous delivery
* Argo CD self-healing

---

# End-to-End Workflow

The final workflow can be summarized as:

```text
1. Developer changes Flask application
                 |
                 v
2. Push code to GitHub
                 |
                 v
3. GitHub Actions runs CI
                 |
                 v
4. Docker image is built
                 |
                 v
5. Image is pushed to Amazon ECR
                 |
                 v
6. Deployment configuration is maintained in Git
                 |
                 v
7. Argo CD detects desired state
                 |
                 v
8. Argo CD deploys Helm chart
                 |
                 v
9. Helm creates Kubernetes resources
                 |
                 v
10. EKS runs Flask pods
                 |
                 v
11. AWS ALB exposes the application
                 |
                 v
12. Flask exposes /metrics
                 |
                 v
13. Prometheus scrapes application metrics
                 |
                 +------------------+
                 |                  |
                 v                  v
             Grafana           Alertmanager
                 |                  |
                 v                  v
               Loki            Notifications
```

---

# Project Goal

The goal of this project is to demonstrate an end-to-end, production-oriented DevOps implementation for a Python Flask application running on AWS.

The project combines:

```text
Application Development
        +
Containerization
        +
CI/CD
        +
Kubernetes
        +
AWS
        +
GitOps
        +
Observability
```

into a single deployable platform.

---

## Status

The platform currently includes:

* [x] Flask application
* [x] Docker containerization
* [x] Amazon ECR
* [x] Amazon EKS
* [x] Helm chart
* [x] Kubernetes Deployment
* [x] Kubernetes Service
* [x] Kubernetes Ingress
* [x] AWS ALB
* [x] HPA
* [x] PDB
* [x] ServiceAccount
* [x] RBAC
* [x] ConfigMap
* [x] Secret
* [x] GitHub Actions
* [x] Argo CD
* [x] Prometheus
* [x] ServiceMonitor
* [x] PrometheusRule
* [x] Grafana
* [x] Alertmanager
* [x] Loki

The next improvements should focus on strengthening CI quality gates, security scanning, deployment promotion between environments, and production-grade alert notification configuration.
