# Flask Python Application — Production-Grade DevOps on AWS EKS

A production-style DevOps project demonstrating how to build, containerize, deploy, monitor, and manage a Flask application on Amazon EKS using modern DevOps and GitOps practices.

## End-to-End Architecture

```text
Developer
   |
   v
GitHub
   |
   v
Pull Request
   |
   v
GitHub Actions
   |
   +--> Tests
   +--> Docker Build
   +--> Security Scan
   +--> AWS OIDC
   |
   v
Amazon ECR
   |
   v
Argo CD / GitOps
   |
   v
Helm
   |
   v
Amazon EKS
   |
   v
AWS Load Balancer Controller
   |
   v
Application Load Balancer
   |
   v
Flask Application
   |
   +------------------+
   |                  |
   v                  v
Prometheus         CloudWatch
   |                  |
   v                  |
Grafana <------------+
   |
   +--> Loki
   |
   +--> Alertmanager
```

## Project Goals

This project demonstrates:

- Python Flask application
- Linux and Git fundamentals
- Docker containerization
- Multi-stage Docker builds
- Kubernetes
- Amazon EKS
- Helm
- Argo CD
- GitOps
- GitHub Actions
- Amazon ECR
- AWS IAM
- GitHub Actions OIDC
- EKS IRSA
- AWS Load Balancer Controller
- Application Load Balancer
- Kubernetes RBAC
- Terraform
- Terraform remote state
- Prometheus
- Grafana
- Loki
- Alertmanager
- AWS CloudWatch
- Trivy
- Cosign

## Technology Stack

| Category | Technology |
|---|---|
| Application | Python / Flask |
| Testing | pytest |
| Container | Docker |
| Registry | Amazon ECR |
| Orchestration | Kubernetes |
| Kubernetes Platform | Amazon EKS |
| Packaging | Helm |
| GitOps / CD | Argo CD |
| CI | GitHub Actions |
| IaC | Terraform |
| Load Balancer | AWS ALB |
| LB Controller | AWS Load Balancer Controller |
| Metrics | Prometheus |
| Visualization | Grafana |
| Logging | Loki |
| Alerting | Alertmanager |
| AWS Monitoring | CloudWatch |
| Image Security | Trivy / Cosign |
| Authentication | AWS IAM / OIDC / IRSA |

## Application

The project contains a Flask web application.

### Endpoints

```text
/
```

Main application dashboard.

```text
/health
```

Health-check endpoint.

```text
/metrics
```

Prometheus metrics endpoint.

The application exposes metrics including:

```text
flask_requests_total
flask_request_duration_seconds
```

These metrics allow monitoring of request rate, request count, and application latency.

## Docker

Docker provides a consistent runtime environment across development, CI, and Kubernetes.

### Build

```bash
docker build -t watchtower .
```

### Run

```bash
docker run -p 5000:5000 watchtower
```

Application:

```text
http://localhost:5000
```

## Amazon ECR

The application image is stored in Amazon ECR.

Repository:

```text
watchtower
```

Example image:

```text
405804178912.dkr.ecr.us-east-1.amazonaws.com/watchtower:<git-sha>
```

Images are tagged using the Git commit SHA so deployments are traceable and immutable.

## Kubernetes

The application runs in Amazon EKS.

Main namespaces:

```text
dev
monitoring
argocd
```

The application deployment includes:

- Deployment
- Service
- ConfigMap
- ServiceAccount
- RBAC
- Ingress
- HPA
- PDB
- ServiceMonitor
- PrometheusRule

### Traffic Flow

```text
Internet
   |
   v
AWS ALB
   |
   v
Kubernetes Ingress
   |
   v
Kubernetes Service
   |
   v
Flask Pod :5000
```

## Amazon EKS

Cluster:

```text
watchtower-dev
```

Region:

```text
us-east-1
```

Configure kubectl:

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name watchtower-dev
```

Verify:

```bash
kubectl get nodes
```

## AWS Load Balancer Controller

The AWS Load Balancer Controller watches Kubernetes Ingress resources and manages the AWS Application Load Balancer.

It uses IAM Roles for Service Accounts (IRSA) instead of static AWS credentials.

ServiceAccount:

```text
aws-load-balancer-controller
```

## Kubernetes RBAC

The Flask application uses:

```text
ServiceAccount: flask-sa
```

RBAC grants the application permission to read Kubernetes pod information.

Verify:

```bash
kubectl auth can-i \
  list pods \
  --as=system:serviceaccount:dev:flask-sa \
  -n dev
```

Expected:

```text
yes
```

## Helm

The application is packaged as the `flask-chart` Helm chart.

The chart manages:

- Deployment
- Service
- ConfigMap
- ServiceAccount
- RBAC
- Ingress
- HPA
- PDB
- ServiceMonitor
- PrometheusRule

Example:

```bash
helm upgrade --install my-python-app ./flask-chart \
  -n dev \
  --create-namespace
```

Environment-specific configuration can be maintained through Helm values files.

## Argo CD

Argo CD provides GitOps-based Continuous Delivery.

```text
Git Repository
      |
      v
Argo CD
      |
      v
Kubernetes
```

Argo CD continuously compares the desired state stored in Git with the actual Kubernetes state.

Key capabilities:

- Automated synchronization
- Self-healing
- Pruning
- Git-based deployments
- Drift detection
- Kubernetes reconciliation

## GitHub Actions

GitHub Actions provides Continuous Integration.

Typical pipeline:

```text
Checkout
   |
   v
Tests
   |
   v
Docker Build
   |
   v
Security Scan
   |
   v
AWS OIDC
   |
   v
Push Image to ECR
```

Workflow files are located under:

```text
.github/workflows/
```

## GitHub Actions OIDC

GitHub Actions authenticates to AWS using OIDC.

```text
GitHub Actions
      |
      v
GitHub OIDC Token
      |
      v
AWS IAM Trust Policy
      |
      v
Assume IAM Role
      |
      v
AWS Resources
```

This avoids storing long-lived AWS access keys in GitHub.

## Terraform

Terraform manages the infrastructure as code.

The Terraform configuration is divided into two layers.

### AWS Layer

```text
terraform-aws/
```

Responsible for AWS infrastructure such as:

- VPC
- Subnets
- Internet Gateway
- NAT Gateway
- Route Tables
- EKS
- Node Groups
- IAM
- OIDC
- ECR
- AWS Load Balancer Controller IAM
- Grafana CloudWatch IAM
- GitHub Actions OIDC

Commands:

```bash
cd terraform-aws

terraform init
terraform validate
terraform fmt -recursive
terraform plan
terraform apply
```

### Kubernetes Layer

```text
terraform-aws/Kubernetes/
```

Responsible for resources that depend on the existing EKS cluster:

- Argo CD
- Prometheus
- Grafana
- Loki
- Alertmanager
- AWS Load Balancer Controller
- Kubernetes namespaces
- ServiceAccounts
- RBAC
- StorageClass
- Flask application

Commands:

```bash
cd terraform-aws/Kubernetes

terraform init
terraform validate
terraform plan
terraform apply
```

### Why Two Terraform Layers?

The AWS layer creates the EKS cluster first.

The Kubernetes layer connects to the already-created EKS cluster.

This separation avoids cluster-dependent Kubernetes and Helm providers being evaluated before the EKS API exists.

## Terraform Remote State

Terraform state is stored remotely in Amazon S3.

AWS layer:

```text
s3://nanda-devops-terraform-state-405804178912/dev/terraform.tfstate
```

Kubernetes layer:

```text
s3://nanda-devops-terraform-state-405804178912/kubernetes/terraform.tfstate
```

Remote state provides:

- Persistent state
- Centralized state management
- Recovery
- Collaboration
- State locking

## Monitoring

The observability architecture is:

```text
Flask /metrics
      |
      v
ServiceMonitor
      |
      v
Prometheus
      |
      +------> Grafana
      |
      +------> Alertmanager

Kubernetes Logs
      |
      v
Loki
      |
      v
Grafana
```

## Prometheus

Prometheus scrapes the Flask `/metrics` endpoint through the ServiceMonitor.

Useful queries:

### Request Rate

```promql
rate(flask_requests_total[5m])
```

### Root Endpoint Rate

```promql
rate(flask_requests_total{exported_endpoint="/"}[5m])
```

### Health Endpoint Rate

```promql
rate(flask_requests_total{exported_endpoint="/health"}[5m])
```

### Total Root Requests

```promql
flask_requests_total{exported_endpoint="/"}
```

### Average Request Latency

```promql
rate(flask_request_duration_seconds_sum[5m])
/
rate(flask_request_duration_seconds_count[5m])
```

### Application Pod Count

```promql
count(
  kube_pod_info{
    namespace="dev",
    pod=~"my-python-app.*"
  }
)
```

## Grafana

Grafana provides dashboards for:

- Kubernetes
- Prometheus
- Application metrics
- Loki
- Alertmanager
- AWS CloudWatch

Existing kube-prometheus-stack dashboards include:

```text
Kubernetes / Views / Global
Kubernetes / Views / Namespaces
Kubernetes / Views / Pods
Kubernetes / Views / Nodes
Prometheus
Loki
Alertmanager
```

## AWS CloudWatch Integration

Grafana accesses AWS CloudWatch using EKS IRSA.

```text
Grafana
   |
   v
monitoring-grafana ServiceAccount
   |
   v
EKS IRSA
   |
   v
AWS IAM Role
   |
   v
CloudWatch
```

This avoids static AWS credentials inside Grafana.

The IAM role provides read access to required CloudWatch metrics and logs.

## Grafana Dashboard Backup

The repository contains the imported CloudWatch dashboard:

```text
monitoring/grafana/dashboards/
└── aws-cloudwatch-infrastructure-monitoring-grafana.json
```

The dashboard definition is stored in Git so it can be retained independently of the Grafana runtime database.

Do not commit:

```text
grafana-backup.db
```

Also do not commit:

```text
*.tfvars
*.tfstate
*.tfstate.*
.env
AWS credentials
private keys
passwords
tokens
```

## Loki

Loki provides centralized Kubernetes log aggregation.

```text
Kubernetes Pods
      |
      v
Loki
      |
      v
Grafana
```

## Alertmanager

Alertmanager receives alerts generated by Prometheus rules.

```text
Prometheus
    |
    v
PrometheusRule
    |
    v
Alertmanager
```

Alerts can be configured for:

- Pod availability
- High CPU
- High memory
- Application availability
- Application error rate

## Container Security

Trivy can scan container images:

```bash
trivy image <image>
```

This helps identify vulnerabilities in:

- Base images
- OS packages
- Python dependencies
- Application dependencies

## Cosign

Cosign can sign container images.

```text
Docker Build
     |
     v
Amazon ECR
     |
     v
Cosign
     |
     v
Signed Image
```

Image signing improves software supply-chain security.

## Project Structure

```text
flask-python-app/
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
│   ├── templates/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── ingress.yaml
│   │   ├── serviceaccount.yaml
│   │   ├── role.yaml
│   │   ├── rolebinding.yaml
│   │   ├── hpa.yaml
│   │   ├── pdb.yaml
│   │   ├── configmap.yaml
│   │   ├── secret.yaml
│   │   ├── servicemonitor.yaml
│   │   └── prometheusrule.yaml
│   │
│   ├── Chart.yaml
│   └── values.yaml
│
├── monitoring/
│   ├── grafana/
│   │   └── dashboards/
│   │       └── aws-cloudwatch-infrastructure-monitoring-grafana.json
│   └── values/
│
├── terraform-aws/
│   ├── bootstrap/
│   ├── modules/
│   │   └── eks/
│   │       └── grafana-cloudwatch.tf
│   │
│   ├── Kubernetes/
│   │   ├── backend.tf
│   │   ├── provider.tf
│   │   ├── variables.tf
│   │   ├── argocd.tf
│   │   ├── monitoring.tf
│   │   ├── load-balancer-controller.tf
│   │   └── ...
│   │
│   ├── backend.tf
│   ├── provider.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── main.tf
│
├── tests/
├── app.py
├── Dockerfile
├── requirements.txt
├── .gitignore
└── README.md
```

## Rebuild From Zero

Clone the repository:

```bash
git clone https://github.com/nanda9/flask-python-app.git
cd flask-python-app
```

Verify AWS identity:

```bash
aws sts get-caller-identity
```

### Step 1 — Create AWS Infrastructure

```bash
cd terraform-aws

terraform init
terraform validate
terraform fmt -recursive
terraform plan
terraform apply
```

### Step 2 — Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name watchtower-dev
```

Verify:

```bash
kubectl get nodes
```

### Step 3 — Create Kubernetes Infrastructure

```bash
cd Kubernetes

terraform init
terraform validate
terraform plan
terraform apply
```

### Step 4 — Verify Argo CD

```bash
kubectl get pods -n argocd
```

```bash
kubectl get applications -n argocd
```

### Step 5 — Verify Monitoring

```bash
kubectl get pods -n monitoring
```

```bash
kubectl get svc -n monitoring
```

### Step 6 — Verify Application

```bash
kubectl get pods -n dev
```

```bash
kubectl get svc -n dev
```

```bash
kubectl get ingress -n dev -o wide
```

### Step 7 — Verify Prometheus

```bash
kubectl get servicemonitor -n dev
```

Then query:

```promql
flask_requests_total
```

### Step 8 — Verify Grafana IRSA

```bash
kubectl get sa monitoring-grafana -n monitoring -o yaml
```

Verify the AWS IAM role annotation.

Then:

```bash
kubectl describe pod \
  -n monitoring \
  monitoring-grafana-0
```

Expected AWS IRSA environment variables include:

```text
AWS_ROLE_ARN
AWS_WEB_IDENTITY_TOKEN_FILE
AWS_REGION
AWS_DEFAULT_REGION
```

## Destroy Environment

Destroy in reverse dependency order.

### Step 1 — Destroy Kubernetes Layer

```bash
cd terraform-aws/Kubernetes

terraform plan -destroy
terraform destroy
```

### Step 2 — Destroy AWS Layer

```bash
cd ..

terraform plan -destroy
terraform destroy
```

Always review the destroy plan before confirming.

Some AWS resources can have dependencies, including:

- NAT Gateways
- Load Balancers
- EKS Node Groups
- Network Interfaces
- Security Groups
- ECR resources
- VPC resources

The Terraform S3 state bucket should normally be retained so the environment can be recreated later.

## Git Workflow

```text
Developer
    |
    v
Feature Branch
    |
    v
Pull Request
    |
    v
GitHub Actions
    |
    +--> Test
    +--> Build
    +--> Scan
    +--> Push
    |
    v
Merge
    |
    v
Argo CD
    |
    v
EKS
```

## Security Principles

### OIDC Instead of Long-Lived AWS Keys

GitHub Actions uses AWS OIDC.

### IRSA Instead of Static Credentials

Grafana and AWS Load Balancer Controller use Kubernetes ServiceAccounts with IAM roles.

### Least Privilege

IAM policies should contain only the permissions required by each workload.

### Container Scanning

Use Trivy to identify image vulnerabilities.

### Image Signing

Use Cosign to establish image provenance and integrity.

### Secrets

Never commit:

```text
*.tfvars
*.tfstate
*.tfstate.*
.env
credentials
private keys
passwords
tokens
runtime databases
```

## Interview Walkthrough

A concise interview explanation can follow this sequence:

### 1. Application

Explain the Flask application and its `/`, `/health`, and `/metrics` endpoints.

### 2. Docker

Explain how Docker creates a consistent and reproducible application runtime.

### 3. Kubernetes

Explain Kubernetes scheduling, self-healing, service discovery, rolling deployments, and scaling.

### 4. EKS

Explain why the managed Amazon EKS control plane is used.

### 5. Helm

Explain how Helm packages Kubernetes resources and supports environment-specific configuration.

### 6. GitHub Actions

Explain Continuous Integration:

```text
Code
→ Test
→ Build
→ Scan
→ Push
```

### 7. ECR

Explain immutable Git SHA image tagging and container storage.

### 8. Argo CD

Explain GitOps Continuous Delivery:

```text
Git
→ Argo CD
→ EKS
```

### 9. AWS Load Balancer Controller

Explain:

```text
Internet
→ ALB
→ Ingress
→ Service
→ Pod
```

### 10. RBAC

Explain how the Flask application securely reads Kubernetes pod information.

### 11. Prometheus

Explain how Prometheus scrapes Flask application metrics.

### 12. Grafana

Explain how metrics and logs are visualized.

### 13. CloudWatch

Explain AWS infrastructure monitoring through Grafana.

### 14. IRSA

Explain how workloads access AWS APIs without static AWS access keys.

### 15. Terraform

Explain infrastructure as code, remote state, and why AWS and Kubernetes Terraform layers are separated.

## End-to-End Production Flow

```text
Developer
   |
   v
GitHub
   |
   v
Pull Request
   |
   v
GitHub Actions
   |
   +--> Unit Tests
   +--> Docker Build
   +--> Security Scan
   +--> AWS OIDC
   |
   v
Amazon ECR
   |
   v
Argo CD / GitOps
   |
   v
Helm
   |
   v
Amazon EKS
   |
   v
AWS ALB
   |
   v
Flask Application
   |
   +----------------------+
   |                      |
   v                      v
Prometheus             CloudWatch
   |                      |
   v                      |
Grafana <----------------+
   |
   +--> Loki
   |
   +--> Alertmanager
```

## Key DevOps Concepts Demonstrated

- Infrastructure as Code
- Immutable infrastructure
- Containerization
- Kubernetes orchestration
- Kubernetes RBAC
- Helm packaging
- GitOps
- Continuous Integration
- Continuous Delivery
- AWS IAM
- GitHub OIDC
- EKS IRSA
- Container security
- Image signing
- Application monitoring
- Infrastructure monitoring
- Centralized logging
- Alerting
- Terraform remote state
- Infrastructure lifecycle management

## Repository

GitHub:

https://github.com/nanda9/flask-python-app

## Summary

This project implements a production-style DevOps platform around a Flask application running on Amazon EKS.

The platform combines:

```text
GitHub
   ↓
GitHub Actions
   ↓
Docker
   ↓
Amazon ECR
   ↓
Argo CD
   ↓
Helm
   ↓
Amazon EKS
   ↓
AWS ALB
   ↓
Flask
   ↓
Prometheus
   ↓
Grafana
   ↓
CloudWatch
```

Terraform manages the infrastructure, GitHub Actions provides CI, Argo CD provides GitOps-based CD, Helm manages Kubernetes packaging, and Prometheus/Grafana/Loki/Alertmanager/CloudWatch provide observability.

The project is designed to demonstrate an end-to-end production-oriented DevOps workflow.
