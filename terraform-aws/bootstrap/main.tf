resource "aws_s3_bucket" "terraform_state" {

  bucket = var.state_bucket_name

  tags = {

    Name = "Terraform State"

    Environment = "Bootstrap"

    ManagedBy = "Terraform"

  }

}

resource "aws_dynamodb_table" "terraform_lock" {

  name = var.lock_table_name

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {

    name = "LockID"

    type = "S"

  }

  tags = {

    Name = "Terraform Lock"

    Environment = "Bootstrap"

    ManagedBy = "Terraform"

  }

}