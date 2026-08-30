# Flask Python Application — Production-Grade DevOps on AWS EKS

A production-oriented Flask application deployed on **Amazon EKS** using **Docker, Amazon ECR, Kubernetes, Helm, GitHub Actions, Argo CD, and Terraform**.

The project demonstrates an end-to-end DevOps workflow from source-code commit through containerization, continuous integration, container image publishing, GitOps-based continuous delivery, Kubernetes orchestration, AWS load balancing, application monitoring, alerting, and infrastructure as code.

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
              +-------------+-------------+
              |                           |
              v                           v
          Run Tests                  Build Docker Image
                                          |
                                          v
                                      Amazon ECR
                                          |
                                          v
                                  Update Git / Helm
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
                                             Service
                                                |
                                                v
                                        AWS ALB / Ingress
                                                |
                                                v
                                              Users
```

### Infrastructure Provisioning

```text
                    Terraform
                       |
          +------------+------------+
          |            |            |
          v            v            v
         VPC          EKS          IAM
          |            |            |
          |            +------------+
          |                 |
          v                 v
       Subnets         Worker Nodes
                            |
                            v
                 AWS Load Balancer
                    Controller
```

### Monitoring and Alerting

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
                 Grafana       Alertmanager
                     |
                     v
                Dashboards
```

---

# Technology Stack

| Area                   | Technology                    |
| ---------------------- | ----------------------------- |
| Application            | Python / Flask                |
| Testing                | pytest                        |
| Containerization       | Docker                        |
| Container Registry     | Amazon ECR                    |
| Kubernetes             | Amazon EKS                    |
| Package Management     | Helm                          |
| CI                     | GitHub Actions                |
| CD / GitOps            | Argo CD                       |
| Infrastructure as Code | Terraform                     |
| Load Balancing         | AWS Application Load Balancer |
| AWS Integration        | AWS Load Balancer Controller  |
| Monitoring             | Prometheus                    |
| Visualization          | Grafana                       |
| Alerting               | Alertmanager                  |
| Application Metrics    | prometheus-client             |
| Kubernetes API         | Kubernetes Python client      |
| Security Scanning      | Trivy                         |
| AWS Authentication     | GitHub Actions OIDC           |

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
│   └── prometheus-values.yaml
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
└── terraform-aws/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── provider.tf
    ├── versions.tf
    ├── terraform.tfvars
    └── modules/
        ├── vpc/
        ├── eks/
        ├── ecr/
        ├── github-oidc/
        └── ...
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

The main application page provides application and environment information and can communicate with the Kubernetes API to retrieve information about running application pods.

Application configuration uses environment variables such as:

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

These probes allow Kubernetes to determine whether the container has started successfully, is ready to receive traffic, and remains healthy.

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

These metrics allow Prometheus to monitor:

* Request volume
* Request latency
* Endpoint traffic
* HTTP methods
* Application availability

The application also exposes standard Python runtime metrics provided by the Prometheus client.

---

# Docker

The application is containerized using Docker.

Docker provides a consistent runtime environment between:

```text
Developer Machine
       |
       v
GitHub Actions
       |
       v
Amazon ECR
       |
       v
Amazon EKS
```

Build the image:

```bash
docker build -t flask-python-app .
```

Tag the image for Amazon ECR:

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

Amazon Elastic Container Registry stores the Docker images used by the EKS deployment.

Repository:

```text
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
```

Images are tagged using Git commit SHA values.

Example:

```text
watchtower:b9a7aba6eaadae3676f7de8af527e29f4d69c085
```

Using Git SHA tags provides immutable version identification and creates traceability between source code and deployed containers.

```text
Git Commit
    |
    v
Docker Image
    |
    v
Amazon ECR
    |
    v
Helm
    |
    v
Argo CD
    |
    v
Kubernetes Pod
```

This is preferable to relying on a mutable:

```text
latest
```

tag.

---

# Terraform

Terraform is used to provision and manage AWS infrastructure.

The infrastructure is designed as Infrastructure as Code so that the environment can be recreated consistently.

The Terraform configuration provisions resources such as:

```text
AWS VPC
 |
 +-- Public Subnets
 |
 +-- Private Subnets
 |
 +-- Internet Gateway
 |
 +-- NAT Gateway
 |
 +-- Route Tables
 |
 +-- EKS Cluster
 |
 +-- EKS Node Group
 |
 +-- IAM Roles
 |
 +-- EKS OIDC Provider
 |
 +-- AWS Load Balancer Controller IAM
 |
 +-- Amazon ECR
 |
 +-- GitHub Actions OIDC
```

Terraform allows the entire AWS environment to be created or destroyed without manually creating individual AWS resources.

Typical workflow:

```bash
terraform init

terraform validate

terraform plan

terraform apply
```

To destroy the environment:

```bash
terraform plan -destroy

terraform apply
```

For cost management during development, the AWS environment can be destroyed when it is not being used and recreated when needed.

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

The application is deployed into:

```text
dev
```

namespace.

---

# Kubernetes Resources

The Helm chart manages Kubernetes resources including:

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

Architecture:

```text
Deployment
    |
    v
ReplicaSet
    |
    v
Flask Pods
```

The deployment uses a rolling update strategy.

Health probes prevent traffic from being routed to containers that are not ready.

The deployment also defines:

* CPU requests
* Memory requests
* CPU limits
* Memory limits
* Startup probe
* Readiness probe
* Liveness probe

---

# Kubernetes Service

The Flask application is exposed internally through a Kubernetes `ClusterIP` Service.

Architecture:

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

The Service routes traffic from the Kubernetes networking layer to the Flask container.

---

# AWS Application Load Balancer

The application is exposed externally using the AWS Load Balancer Controller.

The Kubernetes Ingress uses:

```yaml
ingress:
  enabled: true
  className: alb
```

Architecture:

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

The AWS Load Balancer Controller runs inside the EKS cluster.

It watches Kubernetes resources such as:

```text
Ingress
Service
```

and creates or updates AWS Elastic Load Balancing resources.

The controller uses an IAM role associated with its Kubernetes ServiceAccount through AWS IAM/OIDC.

This allows the controller to interact with AWS without storing long-lived AWS credentials inside Kubernetes.

---

# RBAC

The Flask application communicates with the Kubernetes API.

The application uses a Kubernetes ServiceAccount:

```text
flask-sa
```

and appropriate RBAC permissions.

Inside Kubernetes, the application loads:

```python
config.load_incluster_config()
```

The Kubernetes Python client then communicates with the Kubernetes API using the ServiceAccount identity.

RBAC follows the principle of least privilege by limiting the application to the Kubernetes resources it needs.

---

# Helm

The Flask application is packaged as a Helm chart:

```text
flask-chart/
```

Helm provides:

* Kubernetes templating
* Configuration management
* Reusable deployment definitions
* Environment-specific configuration

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

The container image is configured through Helm values:

```yaml
image:
  repository: 405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower
  pullPolicy: Always
  tag: <GIT_SHA>
```

The image tag can therefore be changed through Git.

---

# CI — GitHub Actions

GitHub Actions provides the Continuous Integration pipeline.

The CI pipeline validates the application, builds the Docker image, performs security scanning, authenticates to AWS using OIDC, and publishes the image to Amazon ECR.

Conceptual workflow:

```text
Git Push
   |
   v
GitHub Actions
   |
   +--> Checkout
   |
   +--> Install Dependencies
   |
   +--> Run Tests
   |
   +--> Build Docker Image
   |
   +--> Trivy Security Scan
   |
   +--> Request GitHub OIDC Token
   |
   +--> Assume AWS IAM Role
   |
   +--> Login to Amazon ECR
   |
   +--> Push Image
   |
   v
Amazon ECR
```

---

# GitHub Actions OIDC

The project uses GitHub Actions OIDC to authenticate GitHub Actions with AWS.

Instead of storing a long-lived AWS access key and secret key in GitHub, GitHub Actions obtains an OIDC identity token and uses it to assume an AWS IAM role.

Architecture:

```text
GitHub Actions
      |
      | OIDC Token
      v
AWS IAM OIDC Provider
      |
      v
GitHub Actions IAM Role
      |
      v
AWS ECR
```

The IAM role can be restricted to the specific GitHub repository and branch.

This improves security because no permanent AWS credentials need to be stored in GitHub Actions secrets.

Terraform manages the AWS-side OIDC resources.

---

# Git SHA Image Versioning

The deployment uses Git commit SHA values as Docker image tags.

Example:

```text
Git Commit
    |
    v
9b9bed84bd0e2c80ca6b4cde19ba14fc8e1b81f8
    |
    v
Docker Image
    |
    v
watchtower:9b9bed84bd0e2c80ca6b4cde19ba14fc8e1b81f8
```

This provides traceability between:

```text
Git Commit
     ↓
Docker Image
     ↓
Amazon ECR
     ↓
Helm Values
     ↓
Argo CD
     ↓
Kubernetes Deployment
```

This approach is more reliable than using mutable image tags such as `latest`.

---

# Argo CD

Argo CD provides Continuous Delivery using the GitOps model.

The Argo CD Application watches:

```text
https://github.com/nanda9/flask-python-app.git
```

and deploys the:

```text
flask-chart
```

into:

```text
dev
```

namespace.

The Argo CD Application uses automated synchronization:

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
Git Desired State
        |
        | compare
        v
Kubernetes Actual State
```

If the desired state changes, Argo CD detects the new Git revision and synchronizes the cluster.

Example:

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
Argo CD detects change
    |
    v
Helm renders manifests
    |
    v
Kubernetes
    |
    v
New Flask Pod
```

---

# Automated Sync

Argo CD automatically synchronizes changes from Git.

For example, changing the Helm image tag:

```yaml
tag: e1c9ddbc72e88a765e871c4ae196a1767fdc08ff
```

to:

```yaml
tag: b9a7aba6eaadae3676f7de8af527e29f4d69c085
```

causes Argo CD to detect the Git change and deploy the new image.

---

# Self-Healing

With:

```yaml
selfHeal: true
```

Argo CD continuously reconciles the Kubernetes cluster.

If a resource is manually changed:

```text
Git Desired State
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

This is one of the key benefits of GitOps.

---

# Pruning

With:

```yaml
prune: true
```

resources removed from the Git desired state can also be removed from Kubernetes.

This prevents obsolete Kubernetes resources from remaining in the environment.

---

# Prometheus

Prometheus provides metrics monitoring for the Kubernetes cluster and Flask application.

The monitoring stack includes:

```text
Prometheus
Alertmanager
Grafana
Node Exporter
Kube State Metrics
Prometheus Operator
```

Prometheus collects:

* Kubernetes infrastructure metrics
* Node metrics
* Pod metrics
* Deployment metrics
* Application metrics

---

# ServiceMonitor

The Flask application exposes:

```text
/metrics
```

A Kubernetes `ServiceMonitor` configures Prometheus to scrape the application.

Example:

```yaml
endpoints:
  - interval: 15s
    path: /metrics
    port: http
```

The ServiceMonitor selects the Flask Service using Kubernetes labels.

This allows Prometheus to automatically discover and scrape the application's metrics.

---

# Application Monitoring

The Flask application exposes metrics such as:

```text
flask_requests_total
flask_request_duration_seconds
```

These metrics can be used to monitor:

```text
Request Volume
Request Latency
Endpoint Traffic
HTTP Methods
Application Availability
```

---

# PrometheusRule

Application alerts are defined using Kubernetes `PrometheusRule` resources.

For example, an alert can detect when a deployment has no available replicas:

```promql
kube_deployment_status_replicas_available{
  namespace="dev",
  deployment="my-python-app-flask-chart"
} < 1
```

Prometheus evaluates the alert condition and sends firing alerts to Alertmanager.

---

# Alertmanager

Alertmanager handles alerts generated by Prometheus.

Architecture:

```text
Prometheus
    |
    | Alert
    v
Alertmanager
    |
    +--> Group
    |
    +--> Deduplicate
    |
    +--> Route
    |
    +--> Notify
```

Alertmanager separates metric evaluation from alert routing and notification.

The project can be configured to send alerts through email or other notification channels.

---

# Grafana

Grafana provides visualization for the monitoring platform.

Prometheus is used as the primary metrics data source.

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

---

## Request Latency

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

# Useful Kubernetes Commands

## Check application pods

```bash
kubectl get pods -n dev
```

## Check services

```bash
kubectl get svc -n dev
```

## Check ingress

```bash
kubectl get ingress -n dev
```

## Check deployment

```bash
kubectl get deployment -n dev
```

## Check HPA

```bash
kubectl get hpa -n dev
```

## Check ServiceMonitor

```bash
kubectl get servicemonitor -n dev
```

## Check PrometheusRule

```bash
kubectl get prometheusrule -n dev
```

## Check Argo CD Application

```bash
kubectl get application my-python-app -n argocd
```

## Check Argo CD synchronization

```bash
kubectl get application my-python-app -n argocd -o wide
```

---

# Helm Validation

Before committing Helm changes:

```bash
helm lint ./flask-chart
```

Render the Kubernetes manifests:

```bash
helm template my-python-app ./flask-chart
```

Save the rendered manifests:

```bash
helm template my-python-app ./flask-chart \
  > /tmp/flask-rendered.yaml
```

Validate the manifests:

```bash
kubectl apply \
  --dry-run=client \
  -f /tmp/flask-rendered.yaml
```

This helps catch Helm and Kubernetes manifest errors before Argo CD synchronizes the application.

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

# End-to-End DevOps Flow

The complete project demonstrates:

```text
1. Developer writes Python code
             |
             v
2. Push code to GitHub
             |
             v
3. GitHub Actions starts
             |
             +--> Run tests
             |
             +--> Build Docker image
             |
             +--> Trivy security scan
             |
             +--> Authenticate to AWS using OIDC
             |
             +--> Push image to Amazon ECR
             |
             v
4. Git/Helm desired state updated
             |
             v
5. Argo CD detects Git change
             |
             v
6. Helm renders Kubernetes manifests
             |
             v
7. EKS deploys new application version
             |
             v
8. AWS ALB exposes application
             |
             v
9. Prometheus collects metrics
             |
             +--> Grafana dashboards
             |
             +--> Alertmanager notifications
```

---

# CI vs CD

One of the main DevOps concepts demonstrated by this project is the separation between CI and CD.

### Continuous Integration

```text
GitHub Actions
```

Responsible for:

* Code checkout
* Dependency installation
* Automated tests
* Docker build
* Security scanning
* ECR image publishing

### Continuous Delivery

```text
Argo CD
```

Responsible for:

* Watching Git
* Detecting configuration changes
* Rendering Helm manifests
* Synchronizing Kubernetes
* Self-healing
* Pruning obsolete resources

Therefore:

```text
CI = GitHub Actions

CD = Argo CD
```

---

# Security

The project demonstrates several DevSecOps practices.

### GitHub OIDC

Avoids storing long-lived AWS access keys in GitHub Actions.

### IAM Least Privilege

GitHub Actions and Kubernetes workloads use dedicated IAM roles with limited permissions.

### Kubernetes RBAC

The Flask application receives only the Kubernetes permissions required for its functionality.

### Container Security

Trivy is used to scan container images for vulnerabilities.

### Immutable Image Tags

Git SHA image tags provide version traceability and reduce the risk associated with mutable tags such as `latest`.

---

# Cost Management

This project uses AWS resources that can generate charges, including:

```text
EKS
EC2 Worker Nodes
NAT Gateway
Elastic IP
Application Load Balancer
ECR
EBS volumes
```

For development and interview practice, the environment can be destroyed when it is not being used.

Terraform allows the infrastructure to be recreated when needed:

```bash
terraform plan
terraform apply
```

and destroyed when finished:

```bash
terraform plan -destroy
terraform apply
```

Before destroying infrastructure, always review the Terraform plan carefully.

---

# Key DevOps Concepts Demonstrated

This project demonstrates practical knowledge of:

### Application

* Python
* Flask
* REST endpoints
* Health checks
* Prometheus metrics

### Containers

* Docker
* Docker image lifecycle
* Amazon ECR
* Immutable image tags

### Kubernetes

* Pods
* Deployments
* Services
* Ingress
* HPA
* PDB
* ConfigMaps
* Secrets
* ServiceAccounts
* RBAC
* Health probes

### AWS

* VPC
* Public/private subnets
* NAT Gateway
* EKS
* ECR
* IAM
* OIDC
* Application Load Balancer
* AWS Load Balancer Controller

### Infrastructure as Code

* Terraform
* Reusable infrastructure
* Terraform modules
* Infrastructure lifecycle management

### CI/CD

* GitHub Actions
* Automated testing
* Docker builds
* Security scanning
* ECR publishing
* Argo CD
* GitOps

### Observability

* Prometheus
* Grafana
* Alertmanager
* ServiceMonitor
* PrometheusRule
* Application metrics

---

# Summary


> I built an end-to-end DevOps pipeline for a Python Flask application running on Amazon EKS. Terraform provisions the AWS infrastructure including the VPC, EKS cluster, worker nodes, ECR, IAM, and GitHub OIDC integration. GitHub Actions performs CI by running tests, building the Docker image, scanning it with Trivy, authenticating to AWS through OIDC, and publishing the image to ECR. Argo CD provides GitOps-based continuous delivery by monitoring the Git repository and synchronizing Helm configuration into EKS. The application is exposed through an AWS Application Load Balancer using the AWS Load Balancer Controller. For observability, the application exposes Prometheus metrics, Prometheus collects them through a ServiceMonitor, Grafana provides dashboards, and Alertmanager handles alerts. The container image is tagged with the Git commit SHA so that every Kubernetes deployment can be traced back to a specific source-code version.
