variable "aws_region" {

  description = "AWS Region"

  type = string

}

variable "state_bucket_name" {

  description = "Terraform state bucket"

  type = string

}

variable "lock_table_name" {

  description = "Terraform lock table"

  type = string

}