output "bucket_name" {
  value = module.demo_bucket.bucket_name
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_arn" {
  value = module.ecr.repository_arn
}
output "github_actions_role_arn" {
  value = module.github_oidc.role_arn
}

output "eks_cluster_role_arn" {
  value = module.eks.cluster_role_arn
}

output "eks_node_role_arn" {
  value = module.eks.node_role_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
