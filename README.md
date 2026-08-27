# Flask Python Application — Production-Grade DevOps on AWS EKS

A production-oriented Flask application deployed to **Amazon EKS** using **Docker, Amazon ECR, Kubernetes, Helm, GitHub Actions, and Argo CD**, with observability using **Prometheus, Grafana, Alertmanager, and Loki**.

The project demonstrates an end-to-end DevOps workflow from source-code commit through containerization, CI, image publishing, GitOps-based deployment, Kubernetes orchestration, AWS load balancing, application metrics, monitoring, and dashboards.

---

## Architecture

### End-to-End Application Delivery

```text
                         Developer
                            |
                            v
                     GitHub Repository
                            |
                            v
                    GitHub Actions CI
                            |
                  +---------+---------+
                  |                   |
                  v                   v
               Tests              Docker Build
                                      |
                                      v
                                  Amazon ECR
                                      |
                                      v
                         Git-based Helm values
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
                         Flask Pod       Kubernetes Service
                                              |
                                              v
                                      AWS ALB / Ingress
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
                       /        \
                      /          \
                     v            v
                 Grafana      Alertmanager
                     |
                     |
                     v
                    Loki
```

---

# Technology Stack

| Area                | Technology                    |
| ------------------- | ----------------------------- |
| Application         | Python / Flask                |
| Testing             | pytest                        |
| Containerization    | Docker                        |
| Container Registry  | Amazon ECR                    |
| Kubernetes          | Amazon EKS                    |
| Package Management  | Helm                          |
| CI                  | GitHub Actions                |
| CD / GitOps         | Argo CD                       |
| Load Balancing      | AWS Application Load Balancer |
| AWS Integration     | AWS Load Balancer Controller  |
| Infrastructure      | Terraform                     |
| Monitoring          | Prometheus                    |
| Visualization       | Grafana                       |
| Alerting            | Alertmanager                  |
| Logging             | Loki                          |
| Application Metrics | prometheus-client             |
| Kubernetes API      | Kubernetes Python client      |
| Security Scanning   | Trivy                         |

---

# Project Structure

```text
flask-python-app/
│
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
├── .dockerignore
├── .gitignore
│
├── tests/
│   └── test_app.py
│
├── .github/
│   └── workflows/
│       ├── build-image.yaml
│       └── test-oidc.yml
│
├── argocd/
│   └── application.yaml
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
├── monitoring/
│   ├── monitoring-values.yaml
│   ├── prometheus-values.yaml
│   └── loki-values.yaml
│
├── static/
│   ├── argocd.png
│   ├── docker.png
│   ├── github.png
│   └── kubernetes.png
│
├── templates/
│   └── index.html
│
├── infrastructure/
│   └── aws/
│
├── terraform-aws/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── versions.tf
│   ├── terraform.tfvars
│   └── bootstrap/
│
└── trivy.json
```

---

# Application

The application is implemented using Python Flask.

The application provides:

```text
GET /
GET /health
GET /metrics
```

## Application Endpoint

```text
GET /
```

The main application page provides application/environment information and interacts with the Kubernetes API to retrieve information about the running application pods.

The application uses environment configuration such as:

```text
APP_NAME
APP_ENV
COMPANY
NAMESPACE
```

---

# Health Endpoint

```text
GET /health
```

Example:

```json
{
  "status": "healthy"
}
```

Kubernetes uses this endpoint for:

* Startup probe
* Readiness probe
* Liveness probe

This allows Kubernetes to determine whether a container has started successfully, whether it is ready to receive traffic, and whether it remains healthy.

---

# Prometheus Metrics

The Flask application exposes:

```text
GET /metrics
```

using the Python `prometheus-client` library.

Example application metrics include:

```text
flask_requests_total
flask_request_duration_seconds
```

The application also exposes the standard Python runtime metrics generated by the Prometheus client.

Example:

```text
# HELP flask_requests_total Total number of Flask requests
# TYPE flask_requests_total counter

flask_requests_total{
    endpoint="/health",
    method="GET"
} 52.0
```

Request latency is exposed as a histogram:

```text
flask_request_duration_seconds
```

This allows Prometheus to measure both:

* Request volume
* Request latency

---

# Docker

The application is containerized using Docker.

Docker provides a consistent runtime environment between development, CI, and Kubernetes.

The image is built and published to Amazon ECR.

Example:

```bash
docker build -t flask-python-app .
```

Tag the image:

```bash
docker tag flask-python-app:latest \
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:<GIT_SHA>
```

Push the image:

```bash
docker push \
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:<GIT_SHA>
```

---

# Amazon ECR

Amazon Elastic Container Registry stores the application container images.

The repository is:

```text
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
```

Images are tagged using Git commit SHA values.

Example:

```text
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:b9a7aba6eaadae3676f7de8af527e29f4d69c085
```

Using Git SHA tags provides immutable version identification.

Instead of deploying:

```text
latest
```

the Kubernetes deployment can reference an exact application version.

---

# Terraform and AWS Infrastructure

Terraform is used to define AWS infrastructure.

The project contains infrastructure configuration for the AWS environment and EKS deployment.

The infrastructure includes components such as:

```text
AWS VPC
   |
   +-- Subnets
   |
   +-- Security configuration
   |
   +-- EKS Cluster
          |
          +-- Worker Nodes
          |
          +-- IAM / OIDC
          |
          +-- AWS Load Balancer Controller
```

Terraform provides infrastructure-as-code and makes the AWS environment reproducible.

---

# Amazon EKS

The Flask application runs on an Amazon EKS cluster.

Kubernetes provides:

* Container orchestration
* Pod scheduling
* Service discovery
* Rolling deployments
* Health checks
* Self-healing
* Resource management
* RBAC
* Horizontal scaling

The application is currently deployed into:

```text
dev
```

namespace.

---

# Kubernetes Resources

The Helm chart manages the application's Kubernetes resources.

Current resources include:

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

---

# Kubernetes Deployment

The application is deployed through a Kubernetes Deployment.

Example architecture:

```text
Deployment
    |
    v
ReplicaSet
    |
    v
Flask Pod
```

The deployment uses a rolling update strategy.

Health probes prevent traffic from being routed to containers that aren't ready.

The deployment also defines:

* CPU/memory requests
* CPU/memory limits
* Startup probe
* Readiness probe
* Liveness probe

---

# Kubernetes Service

The Flask application is exposed internally through a Kubernetes `ClusterIP` Service.

Current architecture:

```text
AWS ALB
   |
   v
Ingress
   |
   v
ClusterIP Service
   |
   v
Flask Pod
```

The Service exposes port:

```text
80
```

and routes traffic to the Flask container's HTTP port.

---

# AWS Application Load Balancer

The application is exposed externally using the AWS Load Balancer Controller.

The Kubernetes Ingress uses:

```yaml
ingress:
  enabled: true
  className: alb
```

The resulting architecture is:

```text
Internet
   |
   v
AWS Application Load Balancer
   |
   v
Kubernetes Ingress
   |
   v
ClusterIP Service
   |
   v
Flask Pod
```

The ALB provides the public entry point for the application.

---

# AWS Load Balancer Controller

The AWS Load Balancer Controller runs inside the EKS cluster and manages AWS Elastic Load Balancing resources based on Kubernetes resources.

It watches Kubernetes objects such as:

```text
Ingress
Service
```

and creates or updates the corresponding AWS load-balancing infrastructure.

The controller uses an IAM role associated with its Kubernetes ServiceAccount through AWS IAM/OIDC.

---

# RBAC

The Flask application communicates with the Kubernetes API.

The application uses a Kubernetes ServiceAccount:

```text
flask-sa
```

and appropriate RBAC permissions.

The application loads the in-cluster Kubernetes configuration:

```python
config.load_incluster_config()
```

The Kubernetes Python client is then used to communicate with the Kubernetes API.

RBAC limits the application's permissions to the Kubernetes resources it needs.

---

# Helm

The Flask application is packaged as a Helm chart:

```text
flask-chart/
```

Helm provides templating and configuration management for Kubernetes.

The chart contains:

```text
Deployment
Service
Ingress
HPA
PDB
ServiceAccount
RBAC
ConfigMap
Secret
ServiceMonitor
PrometheusRule
```

The container image is configured through:

```yaml
image:
  repository: 405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
  pullPolicy: Always
  tag: <GIT_SHA>
```

This allows the deployed image version to be changed through Git.

---

# CI — GitHub Actions

GitHub Actions provides the continuous integration pipeline.

The workflow validates the application and builds the container image.

The CI process is conceptually:

```text
Git Push
   |
   v
GitHub Actions
   |
   +--> Checkout
   |
   +--> Install dependencies
   |
   +--> Run tests
   |
   +--> Build Docker image
   |
   +--> Security scanning
   |
   +--> Push image to ECR
   |
   v
Container image
```

The project also contains an OIDC-related GitHub Actions workflow:

```text
.github/workflows/test-oidc.yml
```

This demonstrates the AWS/GitHub identity integration used for secure CI authentication.

---

# Git SHA Image Versioning

A key part of the deployment design is using Git commit SHA values as container image tags.

Example:

```text
Git commit
   |
   v
9b9bed84bd0e2c80ca6b4cde19ba14fc8e1b81f8
   |
   v
Docker image
   |
   v
watchtower:9b9bed84bd0e2c80ca6b4cde19ba14fc8e1b81f8
```

This creates traceability between:

```text
Git commit
      ↓
Docker image
      ↓
Helm configuration
      ↓
Argo CD deployment
      ↓
Kubernetes pod
```

This is preferable to relying on mutable `latest` tags.

---

# Argo CD

Argo CD provides continuous delivery using GitOps.

The Argo CD Application watches:

```text
https://github.com/nanda9/flask-python-app.git
```

and deploys:

```text
flask-chart
```

to:

```text
dev
```

The Argo CD Application uses:

```yaml
syncPolicy:
  automated:
    prune: true
    selfHeal: true
```

---

# GitOps

The desired Kubernetes state is stored in Git.

Argo CD continuously compares:

```text
Git desired state
        vs
Kubernetes actual state
```

When the desired state changes, Argo CD synchronizes the cluster.

Example:

```text
Git
 |
 | Helm values changed
 | image tag updated
 v
Argo CD
 |
 | detects new Git revision
 v
Helm
 |
 | renders manifests
 v
Kubernetes
 |
 v
New Flask Pod
```

---

# Automated Sync

Argo CD automatically synchronizes changes from Git.

For example, changing:

```yaml
tag: e1c9ddbc72e88a765e871c4ae196a1767fdc08ff
```

to:

```yaml
tag: b9a7aba6eaadae3676f7de8af527e29f4d69c085
```

causes Argo CD to deploy the new image.

---

# Self-Healing

With:

```yaml
selfHeal: true
```

Argo CD continuously reconciles the cluster.

If a resource is manually modified:

```text
Git desired state
       |
       | differs
       v
Kubernetes
       |
       v
Argo CD detects drift
       |
       v
Argo CD restores desired state
```

This is one of the major benefits of GitOps.

---

# Pruning

With:

```yaml
prune: true
```

resources removed from the desired Git state can also be removed from Kubernetes.

This prevents obsolete resources from remaining in the cluster.

---

# Prometheus

Prometheus is deployed into the:

```text
monitoring
```

namespace.

The monitoring stack includes:

```text
Prometheus
Alertmanager
Grafana
Node Exporter
Kube State Metrics
Prometheus Operator
```

Prometheus collects both Kubernetes infrastructure metrics and application metrics.

---

# ServiceMonitor

The Flask application's metrics endpoint is exposed through:

```text
/metrics
```

A Kubernetes `ServiceMonitor` configures Prometheus to scrape the application.

Current configuration:

```yaml
endpoints:
  - interval: 15s
    path: /metrics
    port: http
```

The ServiceMonitor selects the Flask application Service using Kubernetes labels.

Prometheus is configured to discover ServiceMonitors with:

```yaml
serviceMonitorNamespaceSelector: {}
```

and:

```yaml
serviceMonitorSelector:
  matchLabels:
    release: monitoring
```

The application's ServiceMonitor therefore includes:

```yaml
labels:
  release: monitoring
```

This allows Prometheus to discover and scrape the Flask application automatically.

---

# Application Monitoring

The Flask application exposes metrics such as:

```text
flask_requests_total
flask_request_duration_seconds
```

These metrics allow us to monitor:

```text
Request volume
Request latency
Endpoint traffic
HTTP methods
Application availability
```

---

# Useful PromQL Queries

## Application Availability

```promql
sum(
  up{
    job="my-python-app-flask-chart",
    namespace="dev"
  }
)
```

A value of:

```text
1
```

indicates a healthy scrape target.

A value of:

```text
0
```

indicates that Prometheus cannot successfully scrape the target.

---

## Request Rate

```promql
rate(
  flask_requests_total[5m]
)
```

This calculates the average request rate over the previous five minutes.

---

## Requests by Endpoint

```promql
sum by (endpoint) (
  rate(flask_requests_total[5m])
)
```

This shows request traffic broken down by endpoint.

---

## Requests by HTTP Method

```promql
sum by (method) (
  rate(flask_requests_total[5m])
)
```

---

## Average Request Latency

```promql
rate(flask_request_duration_seconds_sum[5m])
/
rate(flask_request_duration_seconds_count[5m])
```

This calculates average request duration.

---

# PrometheusRule

The Helm chart also creates a `PrometheusRule`.

The rule can monitor application availability.

Example:

```promql
kube_deployment_status_replicas_available{
  namespace="dev",
  deployment="my-python-app-flask-chart"
} < 1
```

This detects when the deployment has no available replicas.

The resulting alert can be processed by Alertmanager.

---

# Alertmanager

Alertmanager handles alerts generated by Prometheus.

The architecture is:

```text
Prometheus
    |
    | Alert
    v
Alertmanager
    |
    +--> Group alerts
    |
    +--> Deduplicate
    |
    +--> Route
    |
    v
Notification channel
```

Alertmanager separates alert generation from notification routing.

---

# Grafana

Grafana provides the visualization layer for the monitoring platform.

Prometheus is configured as a Grafana data source.

The dashboard is designed to provide operational visibility into the application and Kubernetes environment.

Current dashboard areas include:

* Application availability
* Request traffic
* Request latency
* Kubernetes workload health
* CPU/memory/resource metrics
* Pod health

---

# Grafana Dashboard

The application dashboard can be used to answer questions such as:

```text
Is the application available?
How much traffic is it receiving?
How long are requests taking?
Are pods healthy?
Are pods restarting?
Is CPU increasing?
Is memory increasing?
Is the deployment healthy?
```

Example request-rate query:

```promql
sum(
  rate(
    flask_requests_total[5m]
  )
)
```

Example endpoint-level query:

```promql
sum by (endpoint) (
  rate(flask_requests_total[5m])
)
```

---

# Loki

Loki is included in the monitoring configuration for centralized logging.

The intended observability architecture is:

```text
Application / Kubernetes logs
             |
             v
            Loki
             |
             v
          Grafana
```

Loki complements Prometheus:

```text
Prometheus → Metrics
Loki       → Logs
Alertmanager → Alerts
Grafana    → Visualization
```

This creates a unified observability platform.

---

# Trivy Security Scanning

The project includes Trivy security scanning.

The scan output is stored in:

```text
trivy.json
```

The purpose of container security scanning is to identify known vulnerabilities in:

* Operating-system packages
* Application dependencies
* Container images

A production CI pipeline can use these results as a security quality gate.

---

# Horizontal Pod Autoscaler

The Helm chart supports HPA:

```yaml
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 1
  targetCPUUtilizationPercentage: 70
```

The current configuration is intentionally:

```text
minReplicas = 1
maxReplicas = 1
```

so the application currently runs with one replica.

The HPA configuration can later be expanded, for example:

```text
minReplicas = 2
maxReplicas = 5
```

to provide actual horizontal scaling based on CPU utilization.

---

# PodDisruptionBudget

The Helm chart includes a PodDisruptionBudget.

A PDB helps protect application availability during voluntary disruptions such as:

```text
Node maintenance
Cluster operations
Pod eviction
Node upgrades
```

For a production environment, the PDB should be configured consistently with the number of application replicas.

---

# Configuration Management

The application uses Kubernetes configuration resources including:

```text
ConfigMap
Secret
```

ConfigMaps are appropriate for non-sensitive configuration.

Secrets are used for sensitive configuration data.

This keeps configuration separate from application code.

---

# Deployment Verification

After deployment, verify the application using:

```bash
kubectl get pods -n dev
```

Expected:

```text
Running
```

Check the deployment:

```bash
kubectl get deployment -n dev
```

Check the Service:

```bash
kubectl get svc -n dev
```

Check the Ingress:

```bash
kubectl get ingress -n dev
```

Check HPA:

```bash
kubectl get hpa -n dev
```

Check ServiceMonitor:

```bash
kubectl get servicemonitor -n dev
```

Check PrometheusRule:

```bash
kubectl get prometheusrule -n dev
```

Check Argo CD:

```bash
kubectl get application my-python-app -n argocd
```

Expected:

```text
SYNC STATUS   HEALTH STATUS
Synced        Healthy
```

---

# Verify Deployed Image

To determine which image is currently deployed:

```bash
kubectl -n dev get deployment my-python-app-flask-chart \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Example:

```text
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:b9a7aba6eaadae3676f7de8af527e29f4d69c085
```

This provides direct traceability from the running Kubernetes deployment back to the Git/image version.

---

# Verify Application Metrics

Check metrics directly from the running pod:

```bash
kubectl exec -n dev <pod-name> -- \
  python -c \
  "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/metrics').read().decode())"
```

Filter Flask metrics:

```bash
kubectl exec -n dev <pod-name> -- \
  python -c \
  "import urllib.request; print(urllib.request.urlopen('http://localhost:5000/metrics').read().decode())" \
  | grep -i flask
```

---

# Helm Validation

Before committing Helm changes:

```bash
helm lint ./flask-chart
```

Render the chart:

```bash
helm template my-python-app ./flask-chart
```

Save rendered manifests:

```bash
helm template my-python-app ./flask-chart \
  > /tmp/flask-rendered.yaml
```

Validate locally:

```bash
kubectl apply \
  --dry-run=client \
  -f /tmp/flask-rendered.yaml
```

---

# Useful Kubernetes Commands

## Pods

```bash
kubectl get pods -n dev
```

## Services

```bash
kubectl get svc -n dev
```

## Ingress

```bash
kubectl get ingress -n dev
```

## Deployment

```bash
kubectl get deployment -n dev
```

## HPA

```bash
kubectl get hpa -n dev
```

## ServiceMonitor

```bash
kubectl get servicemonitor -n dev
```

## PrometheusRule

```bash
kubectl get prometheusrule -n dev
```

## Argo CD Application

```bash
kubectl get application my-python-app -n argocd
```

## All monitoring resources

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

---

# End-to-End CI/CD Flow

The complete workflow is:

```text
                    Developer
                        |
                        v
                  Git Push
                        |
                        v
                  GitHub Repo
                        |
                        v
               GitHub Actions CI
                        |
              +---------+---------+
              |                   |
              v                   v
          Run Tests          Build Image
                                  |
                                  v
                              Trivy Scan
                                  |
                                  v
                              Amazon ECR
                                  |
                                  v
                       Update Helm image tag
                                  |
                                  v
                              Git Commit
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
                                  v
                           Flask Deployment
                                  |
                                  v
                         Kubernetes Service
                                  |
                                  v
                               ALB
                                  |
                                  v
                              Users
```

---

# End-to-End Observability Flow

```text
                    Flask Application
                           |
                           | /metrics
                           v
                     ServiceMonitor
                           |
                           v
                       Prometheus
                           |
             +-------------+-------------+
             |                           |
             v                           v
          Grafana                  Alertmanager
             |
             |
             v
            Loki
```

---

# CI vs CD

A key DevOps distinction demonstrated by this project is:

```text
CI
|
+-- GitHub Actions
    +-- Test
    +-- Build
    +-- Security scan
    +-- Publish image
```

versus:

```text
CD
|
+-- Argo CD
    +-- Watch Git
    +-- Detect desired-state changes
    +-- Render Helm
    +-- Synchronize EKS
    +-- Self-heal
    +-- Prune
```

GitHub Actions is responsible for **building and validating** the software.

Argo CD is responsible for **continuously reconciling the deployment environment**.

---

# Why GitOps?

Without GitOps:

```text
Developer
   |
   v
CI/CD
   |
   v
kubectl apply
   |
   v
Kubernetes
```

With GitOps:

```text
Developer
   |
   v
Git
   |
   v
Argo CD
   |
   v
Kubernetes
```

The second approach provides a Git-based source of truth for the desired Kubernetes state.

Benefits include:

* Auditability
* Version history
* Rollback capability
* Reproducibility
* Drift detection
* Self-healing
* Clear separation between CI and CD

---

# Production Engineering Practices

This project demonstrates the following production-oriented practices:

### Containerization

* Docker
* Immutable image tags
* Amazon ECR

### Kubernetes

* Deployments
* Services
* Ingress
* Health probes
* Resource requests/limits
* HPA
* PDB
* ConfigMaps
* Secrets
* ServiceAccounts
* RBAC

### AWS

* Amazon EKS
* Amazon ECR
* AWS Application Load Balancer
* AWS Load Balancer Controller
* IAM/OIDC

### CI/CD

* GitHub Actions
* Automated testing
* Container builds
* Trivy scanning
* Git SHA image versioning
* Argo CD
* GitOps
* Automated sync
* Self-healing
* Pruning

### Observability

* Prometheus
* ServiceMonitor
* PrometheusRule
* Grafana
* Alertmanager
* Loki
* Application metrics
* Request-rate monitoring
* Request-latency monitoring

### Infrastructure as Code

* Terraform
* AWS infrastructure provisioning
* Reproducible infrastructure

---

# Troubleshooting Lessons

## Argo CD ApplicationSet Controller

During the project, the Argo CD ApplicationSet controller entered:

```text
CrashLoopBackOff
```

The logs showed:

```text
failed to wait for applicationset caches to sync
```

The underlying issue was that:

```text
applicationsets.argoproj.io
```

was missing from the Kubernetes cluster.

After installing the correct ApplicationSet CRD and restarting the controller:

```bash
kubectl rollout restart deployment \
  argocd-applicationset-controller \
  -n argocd
```

the controller returned to:

```text
1/1 Running
```

This demonstrates an important Kubernetes troubleshooting workflow:

```text
Pod failure
   |
   v
Check logs
   |
   v
Identify missing dependency
   |
   v
Check CRDs
   |
   v
Install missing CRD
   |
   v
Restart controller
   |
   v
Verify Running
```

---

# AWS Load Balancer Controller IAM Troubleshooting

The project also encountered an AWS IAM permission problem involving:

```text
elasticloadbalancing:ModifyRule
```

The controller returned:

```text
AccessDenied
```

The important troubleshooting process was:

```text
Ingress event
      |
      v
AWS API AccessDenied
      |
      v
Identify IAM role
      |
      v
Check ServiceAccount annotation
      |
      v
Check attached IAM policy
      |
      v
Check policy version/actions
```

The controller ServiceAccount was associated with:

```text
watchtower-dev-aws-load-balancer-controller
```

and the IAM policy was verified to contain:

```text
elasticloadbalancing:ModifyRule
```

This is a useful example of troubleshooting the relationship between:

```text
Kubernetes ServiceAccount
        +
AWS IAM Role
        +
IAM Policy
        +
AWS API permissions
```

---

# Current Platform Status

The major components of the platform are implemented:

* [x] Flask application
* [x] HTML frontend
* [x] pytest tests
* [x] Docker containerization
* [x] Amazon ECR
* [x] Terraform infrastructure
* [x] Amazon EKS
* [x] Kubernetes Deployment
* [x] Kubernetes Service
* [x] Kubernetes Ingress
* [x] AWS ALB
* [x] AWS Load Balancer Controller
* [x] Health probes
* [x] HPA configuration
* [x] PodDisruptionBudget
* [x] ServiceAccount
* [x] RBAC
* [x] ConfigMap
* [x] Secret
* [x] GitHub Actions
* [x] Git SHA image tagging
* [x] Container security scanning
* [x] Argo CD
* [x] GitOps
* [x] Automated synchronization
* [x] Self-healing
* [x] Prometheus
* [x] ServiceMonitor
* [x] Flask application metrics
* [x] PrometheusRule
* [x] Alertmanager
* [x] Grafana
* [x] Grafana dashboard panels
* [x] Loki configuration

---

# Future Improvements

Potential next steps include:

1. Increase HPA capacity from `1 → 1` to a realistic production range such as `2 → 5`.
2. Add separate `dev`, `staging`, and `production` Helm values.
3. Implement environment promotion through GitOps.
4. Add stronger CI quality gates.
5. Add dependency vulnerability scanning.
6. Configure production Alertmanager notifications.
7. Complete and verify Loki log collection.
8. Add application error-rate alerts.
9. Add latency SLO/SLI dashboards.
10. Add Grafana dashboards for Kubernetes workload health.
11. Add rollback procedures using Git history.
12. Add deployment notifications.
13. Add TLS/HTTPS for the ALB.
14. Add DNS using Route 53.
15. Add centralized secrets management.

---

# Interview Summary

This project can be explained in an interview as:

> I built an end-to-end DevOps platform for a Flask application running on Amazon EKS. The application is containerized with Docker and images are stored in Amazon ECR using Git SHA tags. GitHub Actions handles CI, including testing, image building, and security scanning. Argo CD provides GitOps-based continuous delivery by monitoring the Git repository and synchronizing the Helm-based Kubernetes deployment into EKS. The application is exposed through an AWS Application Load Balancer managed by the AWS Load Balancer Controller. For observability, I exposed Flask application metrics through `/metrics`, created a Kubernetes ServiceMonitor, and configured Prometheus to scrape the application. Grafana provides dashboards, while PrometheusRule and Alertmanager provide alerting. Terraform is used to provision the AWS infrastructure.

The key architecture is:

```text
GitHub
   |
   v
GitHub Actions
   |
   +---- Tests
   +---- Docker Build
   +---- Security Scan
   |
   v
Amazon ECR
   |
   v
Git + Helm
   |
   v
Argo CD
   |
   v
Amazon EKS
   |
   +---- Flask
   +---- Service
   +---- Ingress
   +---- ALB
   |
   v
Users

Flask /metrics
      |
      v
ServiceMonitor
      |
      v
Prometheus
      |
      +---- Grafana
      |
      +---- Alertmanager
      |
      +---- Loki
```

---

# Project Goal

The goal of this project is to demonstrate a complete, production-oriented DevOps implementation rather than simply deploying a Flask application.

It combines:

```text
Application Development
        +
Automated Testing
        +
Containerization
        +
Container Security
        +
Infrastructure as Code
        +
AWS
        +
Kubernetes
        +
Helm
        +
CI/CD
        +
GitOps
        +
Monitoring
        +
Alerting
        +
Observability
```

into a single end-to-end platform.
