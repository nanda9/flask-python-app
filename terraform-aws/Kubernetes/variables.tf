variable "aws_region" {
  description = "AWS region where the EKS cluster is running"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Existing EKS cluster name"
  type        = string
  default     = "watchtower-dev"
}

variable "grafana_smtp_password" {
  description = "Grafana SMTP password"
  type        = string
  sensitive   = true
  default     = ""
}