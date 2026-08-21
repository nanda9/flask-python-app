data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]
}
data "aws_iam_policy_document" "github_assume_role" {

  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test = "StringLike"

      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
      ]
    }
  }
}
resource "aws_iam_role" "github_actions" {

  name = "github-actions-ecr-role"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    ManagedBy = "Terraform"
  }
}
data "aws_iam_policy_document" "ecr" {

  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage"
    ]

    resources = [
      "arn:aws:ecr:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:repository/watchtower"
    ]
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
resource "aws_iam_policy" "github_ecr" {

  name = "github-actions-ecr-policy"

  policy = data.aws_iam_policy_document.ecr.json
}
resource "aws_iam_role_policy_attachment" "github_ecr" {

  role = aws_iam_role.github_actions.name

  policy_arn = aws_iam_policy.github_ecr.arn
}