terraform {
  backend "s3" {
    bucket       = "nanda-devops-terraform-state-405804178912"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}