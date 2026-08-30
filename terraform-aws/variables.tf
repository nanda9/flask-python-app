variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "demo_bucket_name" {
  description = "Demo S3 bucket name"
  type        = string
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
}
variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.34"
}


variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "desired_nodes" {
  description = "Desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Minimum number of EKS nodes"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Maximum number of EKS nodes"
  type        = number
  default     = 3
}

variable "grafana_smtp_password" {
  description = "Grafana SMTP password"
  type        = string
  sensitive   = true
  default     = ""
}