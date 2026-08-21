module "demo_bucket" {

  source = "./modules/s3"

  bucket_name = var.demo_bucket_name

}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.ecr_repository_name
  environment     = "dev"
}

module "github_oidc" {
  source = "./modules/github-oidc"

  github_org  = var.github_org
  github_repo = var.github_repo
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr

  availability_zones = var.availability_zones

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  kubernetes_version = var.kubernetes_version
  environment        = var.environment
  instance_types     = var.instance_types
  desired_nodes      = var.desired_nodes
  min_nodes          = var.min_nodes
  max_nodes          = var.max_nodes
}