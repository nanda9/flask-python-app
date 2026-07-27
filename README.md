<div align="center">

# 🚀 End-to-End DevOps Platform

### GitHub Actions • Docker • Kubernetes • Helm • Argo CD • Prometheus • Grafana • Loki • Alertmanager

<p align="center">

![Python](https://img.shields.io/badge/Python-3.11-blue?logo=python)
![Flask](https://img.shields.io/badge/Flask-Web_App-black?logo=flask)
![GitHub](https://img.shields.io/badge/GitHub-Repository-black?logo=github)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI-blue?logo=githubactions)
![Docker](https://img.shields.io/badge/Docker-Container-blue?logo=docker)
![Docker Hub](https://img.shields.io/badge/Docker_Hub-Registry-2496ED?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes)
![Helm](https://img.shields.io/badge/Helm-Package_Manager-0F1689?logo=helm)
![Argo CD](https://img.shields.io/badge/ArgoCD-GitOps-orange?logo=argo)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus)
![Grafana](https://img.shields.io/badge/Grafana-Dashboard-F46800?logo=grafana)
![Loki](https://img.shields.io/badge/Loki-Logging-7B42BC)
![Alertmanager](https://img.shields.io/badge/Alertmanager-Email_Alerts-red)
![License](https://img.shields.io/badge/License-MIT-green)

</p>

---

## Production-Style GitOps CI/CD Platform

**A complete DevOps implementation demonstrating Continuous Integration, Continuous Delivery, GitOps, Kubernetes orchestration, centralized logging, monitoring, and alerting.**

Built using modern cloud-native technologies and DevOps best practices.

</div>

---

# 📚 Table of Contents

- Project Overview
- Objectives
- Features
- Architecture
- Technology Stack
- DevOps Workflow
- Repository Structure
- Installation
- Kubernetes Deployment
- CI/CD Pipeline
- Monitoring
- Logging
- Alerting

---

# 📖 Project Overview

This project demonstrates a **production-inspired GitOps CI/CD platform** built using modern DevOps tools and cloud-native technologies.

The application automatically progresses through the following lifecycle:

- Source Code Management
- Continuous Integration
- Docker Image Creation
- Docker Registry Publishing
- GitOps Deployment
- Kubernetes Orchestration
- Monitoring
- Centralized Logging
- Alerting
- Self-Healing Infrastructure

Every Git push automatically triggers a CI/CD pipeline that builds a Docker image, publishes it to Docker Hub, and synchronizes Kubernetes deployments using Argo CD.

The platform also includes a complete observability stack with Prometheus, Grafana, Loki, Promtail, and Alertmanager.

---

# 🎯 Project Objectives

The primary goals of this project are to demonstrate:

- Production-ready CI/CD pipeline
- GitOps deployment strategy
- Kubernetes application deployment
- Helm package management
- Containerized Python application
- Centralized logging
- Infrastructure monitoring
- Automated alerting
- Infrastructure as Code principles
- End-to-End DevOps workflow

---

# ⭐ Features

## CI/CD

- Automated GitHub Actions Pipeline
- Docker Image Build
- Docker Hub Push
- Automatic Deployment
- GitOps Workflow
- Continuous Delivery

---

## Containerization

- Docker
- Production Gunicorn Server
- Optimized Python Image
- Lightweight Deployment

---

## Kubernetes

- Deployments
- ReplicaSets
- Services
- Ingress
- Namespace Isolation
- Rolling Updates
- Self-Healing
- High Availability

---

## GitOps

- Argo CD
- Auto Sync
- Self Heal
- Drift Detection
- Declarative Deployments

---

## Monitoring

- Prometheus
- Node Exporter
- kube-state-metrics
- Grafana Dashboards

---

## Logging

- Loki
- Promtail
- Kubernetes Log Collection
- LogQL Queries

---

## Alerting

- Alertmanager
- Gmail SMTP Integration
- Email Notifications
- Prometheus Alert Rules

---

# 🏗 High-Level Architecture

```text
                        Developer

                            │

                     Git Push to GitHub

                            │

                            ▼

                 GitHub Actions (CI Pipeline)

                            │

             Build Docker Image & Run Checks

                            │

                            ▼

                     Push Image to Docker Hub

                            │

                            ▼

                     GitOps with Argo CD

                            │

                            ▼

                        Helm Chart

                            │

                            ▼

                    Kubernetes Cluster

        ┌───────────────────┼────────────────────┐

        │                   │                    │

        ▼                   ▼                    ▼

    Flask App         Prometheus             Loki

        │                  │                  │

        │                  ▼                  ▼

        │             Grafana          Promtail

        │

        ▼

 Alertmanager

        │

        ▼

 Gmail Notifications
```

---

# 🔄 End-to-End DevOps Workflow

```text
Developer

↓

GitHub Repository

↓

GitHub Actions

↓

Docker Build

↓

Docker Hub

↓

Argo CD

↓

Helm

↓

Kubernetes

↓

Flask Application

↓

Prometheus Metrics

↓

Grafana Dashboards

↓

Loki Logs

↓

Alertmanager

↓

Gmail Alerts
```

---

# 🛠 Technology Stack

| Category | Technology |
|-----------|------------|
| Language | Python 3.11 |
| Framework | Flask |
| Web Server | Gunicorn |
| Containerization | Docker |
| Source Control | GitHub |
| CI | GitHub Actions |
| Container Registry | Docker Hub |
| GitOps | Argo CD |
| Orchestration | Kubernetes |
| Package Manager | Helm |
| Monitoring | Prometheus |
| Dashboards | Grafana |
| Logging | Loki |
| Log Collection | Promtail |
| Alerting | Alertmanager |
| Ingress | NGINX Ingress |
| Cluster | Minikube |

---

# 🎓 Skills Demonstrated

This project demonstrates practical experience with:

- Python Application Deployment
- Linux
- Docker
- Docker Hub
- Kubernetes
- Helm
- GitHub Actions
- Argo CD
- GitOps
- CI/CD
- Prometheus
- Grafana
- Loki
- Promtail
- Alertmanager
- Gmail SMTP Integration
- Kubernetes Ingress
- Rolling Updates
- Monitoring
- Observability
- Production Troubleshooting

---

# 🌟 Why This Project?

This project simulates how modern organizations deploy and manage applications in Kubernetes using GitOps principles.

Instead of manually deploying containers, every code change automatically follows a complete software delivery lifecycle:

- Developer commits code
- CI pipeline builds and validates the application
- Docker image is published
- Argo CD detects Git changes
- Kubernetes is automatically synchronized
- Prometheus monitors the application
- Grafana visualizes metrics
- Loki aggregates logs
- Alertmanager sends notifications

This demonstrates a production-style DevOps workflow from development to observability.

- # 📁 Repository Structure

```text
end-to-end-devops-platform/
│
├── app.py
├── requirements.txt
├── Dockerfile
├── README.md
│
├── templates/
│     └── index.html
│
├── static/
│     ├── github.png
│     ├── docker.png
│     ├── kubernetes.png
│     ├── argocd.png
│     └── company-logo.png
│
├── helm/
│     └── flask-chart/
│           ├── Chart.yaml
│           ├── values.yaml
│           └── templates/
│                  ├── deployment.yaml
│                  ├── service.yaml
│                  ├── ingress.yaml
│                  ├── hpa.yaml
│                  └── _helpers.tpl
│
├── monitoring/
│     ├── monitoring-values.yaml
│     ├── prometheus-rules.yaml
│     ├── servicemonitor.yaml
│     └── alertmanager.yaml
│
├── .github/
│     └── workflows/
│            └── docker-ci.yml
│
└── screenshots/
      ├── dashboard.png
      ├── argocd.png
      ├── grafana.png
      ├── prometheus.png
      ├── loki.png
      └── alertmanager.png
```

---

# ⚙️ Prerequisites

The following software is required to run this project.

| Software | Version |
|-----------|----------|
| Python | 3.11 |
| Docker Desktop | Latest |
| Kubernetes | v1.33+ |
| Minikube | Latest |
| kubectl | Latest |
| Helm | v3+ |
| Git | Latest |
| GitHub Account | Required |
| Docker Hub Account | Required |

---

# 🚀 Getting Started

Clone the repository.

```bash
git clone https://github.com/<your-github>/end-to-end-devops-platform.git

cd end-to-end-devops-platform
```

---

## Create Virtual Environment

```bash
python3 -m venv venv
```

Activate it

Mac/Linux

```bash
source venv/bin/activate
```

Windows

```powershell
venv\Scripts\activate
```

---

## Install Dependencies

```bash
pip install -r requirements.txt
```

---

## Run Flask Application

```bash
python app.py
```

Application

```
http://localhost:5000
```

---

# 🐳 Docker

## Build Docker Image

```bash
docker build -t my-python-app .
```

Verify

```bash
docker images
```

Run

```bash
docker run -d \
-p 5000:5000 \
my-python-app
```

Check

```bash
docker ps
```

Application

```
http://localhost:5000
```

---

# 📦 Push Image to Docker Hub

Login

```bash
docker login
```

Tag image

```bash
docker tag my-python-app \
docker-username/my-python-app:latest
```

Push

```bash
docker push docker-username/my-python-app:latest
```

Docker Hub

```
https://hub.docker.com/r/docker-username/my-python-app
```

---

# ☸ Kubernetes Cluster

Start Minikube

```bash
minikube start
```

Verify

```bash
kubectl get nodes
```

Expected

```text
NAME        STATUS

minikube    Ready
```

---

# 📦 Namespace

Create namespace

```bash
kubectl create namespace dev
```

Verify

```bash
kubectl get ns
```

---

# 🚀 Deploy using Helm

Move into Helm chart

```bash
cd helm/flask-chart
```

Install

```bash
helm install flask-app . \
-n dev
```

Upgrade

```bash
helm upgrade flask-app . \
-n dev
```

Rollback

```bash
helm rollback flask-app 1
```

Uninstall

```bash
helm uninstall flask-app \
-n dev
```

---

# 📋 Verify Deployment

Pods

```bash
kubectl get pods -n dev
```

Deployments

```bash
kubectl get deployment -n dev
```

ReplicaSets

```bash
kubectl get rs -n dev
```

Services

```bash
kubectl get svc -n dev
```

Ingress

```bash
kubectl get ingress -n dev
```

---

# 🌐 Ingress

Enable ingress

```bash
minikube addons enable ingress
```

Start tunnel

```bash
minikube tunnel
```

Add hosts entry

```text
127.0.0.1 flask.local
```

Application

```
http://flask.local
```

---

# 📈 High Availability

The application runs with multiple replicas.

```yaml
replicas: 3
```

Benefits

- Zero downtime deployment
- High availability
- Load balancing
- Self healing

---

# 🔄 Rolling Updates

Update image

```bash
helm upgrade flask-app . \
-n dev
```

Observe rollout

```bash
kubectl rollout status deployment/my-python-app-flask-chart \
-n dev
```

History

```bash
kubectl rollout history deployment/my-python-app-flask-chart \
-n dev
```

Undo

```bash
kubectl rollout undo deployment/my-python-app-flask-chart \
-n dev
```

---

# ❤️ Kubernetes Self-Healing

Delete a pod

```bash
kubectl delete pod \
<pod-name> \
-n dev
```

Kubernetes automatically creates a replacement pod.

This demonstrates the self-healing capability of Kubernetes.

---

# ⚙️ Horizontal Scaling

Scale manually

```bash
kubectl scale deployment \
my-python-app-flask-chart \
--replicas=5 \
-n dev
```

Verify

```bash
kubectl get pods -n dev
```

Scale down

```bash
kubectl scale deployment \
my-python-app-flask-chart \
--replicas=3 \
-n dev
```

---

# 🏗 Helm Chart Components

The Helm chart includes:

| File | Purpose |
|------|----------|
| Chart.yaml | Chart metadata |
| values.yaml | Configurable values |
| deployment.yaml | Kubernetes Deployment |
| service.yaml | Kubernetes Service |
| ingress.yaml | NGINX Ingress |
| hpa.yaml | Horizontal Pod Autoscaler |
| _helpers.tpl | Template helper functions |

---

# 📌 Key Concepts Demonstrated

✅ Docker Image Build

✅ Docker Hub Registry

✅ Kubernetes Deployments

✅ ReplicaSets

✅ Pods

✅ Services

✅ Ingress

✅ Helm Charts

✅ Rolling Updates

✅ Rollback

✅ Scaling

✅ Self-Healing

---

# 🔄 Continuous Integration & Continuous Delivery (CI/CD)

One of the primary objectives of this project is to automate the complete software delivery lifecycle.

Instead of manually building Docker images and deploying Kubernetes resources, the entire process is fully automated using **GitHub Actions** and **Argo CD** following **GitOps** principles.

---

# 🚀 CI/CD Workflow

```text
Developer

    │

    ▼

Git Push

    │

    ▼

GitHub Repository

    │

    ▼

GitHub Actions

    │

    ├─────────────── Checkout Source

    ├─────────────── Build Docker Image

    ├─────────────── Run Docker Build Validation

    ├─────────────── Login Docker Hub

    └─────────────── Push Image

                     │

                     ▼

               Docker Hub

                     │

                     ▼

            Update Helm Values

                     │

                     ▼

                Argo CD Sync

                     │

                     ▼

              Kubernetes Cluster

                     │

                     ▼

             Rolling Deployment

                     │

                     ▼

             New Application Version
```

---

# ⚡ Continuous Integration

Every Git push automatically starts a GitHub Actions workflow.

The pipeline performs:

- Checkout latest source code
- Configure Docker Buildx
- Authenticate with Docker Hub
- Build Docker image
- Push Docker image
- Complete pipeline validation

---

# 📂 GitHub Actions Workflow

Project Location

```
.github/workflows/docker-ci.yml
```

Responsibilities

- Continuous Integration
- Docker Build
- Docker Registry Authentication
- Docker Push

---

# 🚀 GitHub Actions Pipeline

The pipeline executes the following steps.

## Step 1

Checkout repository

```yaml
uses: actions/checkout@v4
```

Purpose

Downloads the latest application source code from GitHub.

---

## Step 2

Setup Docker Buildx

```yaml
uses: docker/setup-buildx-action@v3
```

Purpose

Creates a modern Docker builder capable of multi-platform image builds.

---

## Step 3

Authenticate Docker Hub

```yaml
uses: docker/login-action@v3
```

Uses GitHub Secrets

```
DOCKER_USERNAME

DOCKER_PASSWORD
```

Purpose

Securely logs into Docker Hub.

---

## Step 4

Build Docker Image

```bash
docker build
```

Purpose

Creates the production Docker image.

---

## Step 5

Push Docker Image

```bash
docker push
```

Purpose

Publishes the latest application image to Docker Hub.

---

# 🔐 GitHub Secrets

Sensitive information is never stored inside the repository.

The project uses GitHub Secrets.

| Secret | Purpose |
|---------|----------|
| DOCKER_USERNAME | Docker Hub Username |
| DOCKER_PASSWORD | Docker Hub Password |

Benefits

- Secure
- Encrypted
- Not exposed in repository

---

# 🐳 Docker Image Strategy

Current repository

```
docker-username/my-python-app
```

Pipeline automatically pushes

```
latest
```

Example

```
docker-username/my-python-app:latest
```

For production deployments, immutable image tags (for example, Git commit SHAs or semantic versions) are generally preferred because they provide traceability and reproducibility. This project currently uses the `latest` tag for simplicity while demonstrating the CI/CD workflow.

---

# 📦 Docker Hub

After every successful build

```
GitHub Actions

↓

Docker Hub

↓

Latest Image Available
```

Verify

```
docker pull docker-username/my-python-app:latest
```

---

# 🚀 Continuous Delivery

Continuous Delivery is implemented using **Argo CD**.

Instead of running

```
kubectl apply
```

Argo CD continuously monitors the Git repository and synchronizes the Kubernetes cluster to match the desired state.

---

# ☸ GitOps

Git becomes the single source of truth.

```text
Git Repository

↓

Desired State

↓

Argo CD

↓

Actual Kubernetes State
```

Benefits

- Declarative deployments
- Easy rollback
- Version control
- Audit history
- Automatic synchronization

---

# 🎯 Argo CD Features

This project demonstrates

- Automatic Sync
- Self Heal
- Continuous Delivery
- GitOps
- Declarative Deployments

---

# 🔄 Auto Sync

Whenever a change is pushed

```
GitHub

↓

Argo CD detects change

↓

Sync starts

↓

Helm Release Updated

↓

Deployment Updated

↓

Pods Restarted
```

No manual deployment required.

---

# ❤️ Self Heal

If someone manually changes a Deployment

```
kubectl edit deployment
```

Argo CD detects configuration drift and restores the desired configuration stored in Git.

---

# 🔍 Drift Detection

Example

Developer edits Deployment manually

↓

Actual cluster

≠

Git Repository

↓

Argo CD detects drift

↓

Automatically restores Git version

---

# 🚀 Rolling Update

New Docker image

↓

Deployment Updated

↓

ReplicaSet Created

↓

Pods Replaced

↓

Zero Downtime

---

# 📊 Deployment Verification

Applications

```bash
kubectl get deployments -n dev
```

Pods

```bash
kubectl get pods -n dev
```

ReplicaSets

```bash
kubectl get rs -n dev
```

Argo Application

```bash
kubectl get applications -n argocd
```

---

# 🌐 Argo CD Dashboard

Launch UI

```bash
kubectl port-forward svc/argocd-server \
-n argocd \
8080:443
```

Open

```
https://localhost:8080
```

Features

- Sync Status
- Health Status
- Resource Tree
- History
- Rollback
- Events
- Logs

---

# 📈 Complete Deployment Flow

```text
Developer

↓

Git Commit

↓

Git Push

↓

GitHub Repository

↓

GitHub Actions

↓

Docker Build

↓

Docker Push

↓

Docker Hub

↓

Helm Values

↓

Argo CD

↓

Kubernetes

↓

Pods Updated

↓

Application Available
```

---

# 💡 CI/CD Benefits

This implementation provides

- Automated builds
- Automated deployments
- Reduced human error
- GitOps workflow
- Version-controlled infrastructure
- Reproducible deployments
- Faster delivery
- Reliable rollbacks

---

# 🎓 Skills Demonstrated

✔ GitHub Actions

✔ Docker

✔ Docker Hub

✔ GitHub Secrets

✔ Continuous Integration

✔ Continuous Delivery

✔ GitOps

✔ Argo CD

✔ Kubernetes

✔ Helm

✔ Rolling Updates

✔ Self Heal

✔ Drift Detection

✔ Zero Downtime Deployment

# 📊 Observability Stack

Modern production systems require more than application deployment—they need complete observability.

This project implements a full observability stack using:

- Prometheus (Metrics Collection)
- Grafana (Visualization)
- Loki (Centralized Logging)
- Promtail (Log Collection)
- Alertmanager (Alert Routing)
- Gmail SMTP (Email Notifications)

---

# 🏗 Observability Architecture

```text
                    Kubernetes Cluster
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
     Flask App       Node Exporter     kube-state-metrics
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                           ▼
                     Prometheus
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
        Grafana                     Alertmanager
                                          │
                                          ▼
                                   Gmail Notifications

----------------------------------------------------------

                Kubernetes Pod Logs

                         │

                         ▼

                    Promtail

                         │

                         ▼

                       Loki

                         │

                         ▼

                     Grafana Logs
```

---

# 📈 Prometheus

Prometheus is responsible for collecting time-series metrics from Kubernetes resources and applications.

## Metrics Collected

- CPU Usage
- Memory Usage
- Pod Health
- Deployment Status
- Node Metrics
- Container Metrics
- Network Metrics
- Disk Usage

---

## Components

This project uses:

- Prometheus Server
- Node Exporter
- kube-state-metrics
- Prometheus Operator

---

## Verify Prometheus

```bash
kubectl get pods -n monitoring
```

Access UI

```bash
kubectl port-forward svc/monitoring-kube-prometheus-prometheus \
-n monitoring \
9090:9090
```

Open

```
http://localhost:9090
```

---

## Useful Prometheus Queries

### Running Pods

```promql
up
```

---

### CPU Usage

```promql
rate(container_cpu_usage_seconds_total[5m])
```

---

### Memory Usage

```promql
container_memory_usage_bytes
```

---

### Pod Status

```promql
kube_pod_status_phase
```

---

### Node Status

```promql
kube_node_status_condition
```

---

# 📊 Grafana

Grafana provides dashboards for monitoring Kubernetes resources and application performance.

---

## Access Grafana

```bash
kubectl port-forward svc/monitoring-grafana \
-n monitoring \
3000:80
```

Open

```
http://localhost:3000
```

---

## Default Login

Username

```
admin
```

Password

```bash
kubectl get secret \
monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-password}" | base64 --decode
```

---

## Dashboards Used

- Kubernetes Cluster
- Node Exporter
- Pod Monitoring
- Kubernetes Resources
- Loki Logs
- Prometheus Metrics

---

## Grafana Data Sources

Configured:

- Prometheus
- Loki

---

# 📜 Loki

Loki is the centralized log aggregation system.

Instead of SSH'ing into Kubernetes nodes, logs are collected centrally and queried from Grafana.

---

## Advantages

- Lightweight
- Kubernetes Native
- Label-based Indexing
- LogQL Support
- Tight Grafana Integration

---

## Components

- Loki
- Loki Gateway
- Loki Canary

---

## Verify Loki

```bash
kubectl get pods -n monitoring
```

---

## Verify Service

```bash
kubectl get svc -n monitoring
```

Expected service

```
loki-gateway
```

---

# 📦 Promtail

Promtail runs as a DaemonSet and collects logs from every Kubernetes node.

Workflow

```text
Container

↓

stdout

↓

Pod Logs

↓

Promtail

↓

Loki

↓

Grafana
```

---

## Verify Promtail

```bash
kubectl get pods -n monitoring
```

Example

```
promtail-xxxxx
```

---

# 🔎 Log Queries (LogQL)

Open Grafana

↓

Explore

↓

Select Loki

---

## All Logs

```logql
{}
```

---

## Logs by Namespace

```logql
{namespace="dev"}
```

---

## Flask Application Logs

```logql
{app="flask-chart"}
```

---

## Pod Logs

```logql
{pod="my-python-app-flask-chart-xxxxx"}
```

---

## Error Logs

```logql
{namespace="dev"} |= "ERROR"
```

---

## Warning Logs

```logql
{namespace="dev"} |= "WARNING"
```

---

## Gunicorn Logs

```logql
{container="flask"}
```

---

# 📧 Alertmanager

Alertmanager receives alerts from Prometheus and routes them to configured notification channels.

This project uses:

- Gmail SMTP

---

## Alert Flow

```text
Prometheus

↓

Alert Rule

↓

Alertmanager

↓

SMTP

↓

Gmail
```

---

## Alerts Configured

- Pod Down
- Deployment Unavailable
- Target Down
- High CPU (example)
- High Memory (example)
- Watchdog

---

## Verify Alertmanager

```bash
kubectl get pods -n monitoring
```

Access UI

```bash
kubectl port-forward \
svc/monitoring-kube-prometheus-alertmanager \
-n monitoring \
9093:9093
```

Open

```
http://localhost:9093
```

---

# ✉ Gmail Notifications

SMTP Server

```
smtp.gmail.com
```

Port

```
587
```

Authentication

- SMTP Username
- App Password

---

## Example Alert Email

```
Status: FIRING

Alert:

KubeDeploymentReplicasMismatch

Namespace:

dev

Deployment:

my-python-app-flask-chart

Severity:

warning
```

---

# 🧪 Testing Alerts

Scale deployment to zero

```bash
kubectl scale deployment \
my-python-app-flask-chart \
--replicas=0 \
-n dev
```

Result

- Pods terminate
- Prometheus detects issue
- Alertmanager fires alert
- Gmail notification received

Restore

```bash
kubectl scale deployment \
my-python-app-flask-chart \
--replicas=3 \
-n dev
```

---

# 📋 Monitoring Commands

Pods

```bash
kubectl get pods -n monitoring
```

Services

```bash
kubectl get svc -n monitoring
```

Prometheus Targets

```
http://localhost:9090/targets
```

Grafana

```
http://localhost:3000
```

Alertmanager

```
http://localhost:9093
```

---

# 🎯 Skills Demonstrated

✔ Prometheus

✔ PromQL

✔ Grafana

✔ Dashboards

✔ Loki

✔ LogQL

✔ Promtail

✔ Kubernetes Logging

✔ Alertmanager

✔ Gmail SMTP

✔ Monitoring

✔ Logging

✔ Alerting

✔ Observability

---

## 📌 Summary

This observability stack provides:

- Real-time metrics collection
- Interactive dashboards
- Centralized Kubernetes logging
- Email alerting
- Production-style monitoring
- Faster troubleshooting and incident response

# 📸 Project Screenshots

> Replace the placeholder images below with screenshots from your own project.

## 🏠 Application Dashboard

![Application Dashboard](screenshots/dashboard.png)

Shows:

- Flask application
- Kubernetes pod information
- Current pod hostname
- CI/CD pipeline overview
- Technology stack
- Cluster health

---

## 🚀 Argo CD Dashboard

![ArgoCD](screenshots/argocd.png)

Features demonstrated:

- Healthy application
- Synced application
- Resource tree
- Deployment history
- Live synchronization

---

## 📊 Grafana Dashboard

![Grafana](screenshots/grafana.png)

Dashboards include:

- Kubernetes Cluster Monitoring
- Node Metrics
- Pod Metrics
- CPU Usage
- Memory Usage
- Loki Logs

---

## 📈 Prometheus

![Prometheus](screenshots/prometheus.png)

Demonstrates

- Active Targets
- Alert Rules
- PromQL Queries
- Time Series Metrics

---

## 📜 Loki Logs

![Loki](screenshots/loki.png)

Shows

- Kubernetes Pod Logs
- Namespace Filtering
- LogQL Queries
- Centralized Logging

---

## 📧 Alertmanager

![Alertmanager](screenshots/alertmanager.png)

Configured with

- Gmail SMTP
- Alert Routing
- Active Alerts
- Alert History

---

## ⚙ GitHub Actions

![GitHub Actions](screenshots/github-actions.png)

Pipeline stages

- Checkout
- Docker Build
- Docker Login
- Docker Push
- Successful Build

---

## 🐳 Docker Hub

![Docker Hub](screenshots/dockerhub.png)

Repository

```
docker-username/my-python-app
```

Latest image automatically published.

---

# 💼 Skills Demonstrated

This project demonstrates hands-on experience with:

- Python
- Flask
- Linux
- Git
- GitHub
- GitHub Actions
- Docker
- Docker Hub
- Kubernetes
- Helm
- Argo CD
- GitOps
- Prometheus
- Grafana
- Loki
- Promtail
- Alertmanager
- NGINX Ingress
- Monitoring
- Logging
- Observability
- CI/CD
- Rolling Updates
- Kubernetes Self-Healing
- High Availability

---

# 🚀 Future Improvements

Potential enhancements include:

- Amazon EKS
- Terraform
- SonarQube
- Trivy
- HashiCorp Vault
- Istio Service Mesh
- KEDA
- Horizontal Pod Autoscaler metrics
- Canary Deployments
- Blue/Green Deployments
- Multi-Cluster GitOps
- GitHub OIDC Authentication
- AWS CloudWatch Integration


# 📚 Key Learning Outcomes

This project provided practical experience in:

- Building a complete CI/CD pipeline
- Deploying applications using GitOps
- Managing Kubernetes resources
- Packaging applications with Helm
- Monitoring production workloads
- Collecting and querying centralized logs
- Configuring automated email alerts
- Troubleshooting Kubernetes deployments
- Operating a cloud-native observability stack


# 👨‍💻 Author

**Nandakumar**

DevOps Engineer | Python | Docker | Kubernetes | GitHub Actions | Argo CD | Prometheus | Grafana | Loki

GitHub: https://github.com/nanda9

Docker Hub: https://hub.docker.com/r/docker-username


# 🙏 Acknowledgements

This project was built for learning and demonstrating modern DevOps practices using open-source technologies.

Special thanks to the maintainers of:

- Kubernetes
- Helm
- Argo CD
- Prometheus
- Grafana
- Loki
- Docker
- GitHub Actions


⭐ **If you found this project useful, consider giving the repository a star!**
