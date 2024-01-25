provider "aws" {
  region = "<VALUE>"
}

data "tls_certificate" "gitlab_ci_oidc" {
  url = var.gitlab_tls_url
}

resource "aws_iam_openid_connect_provider" "gitlab_ci_oidc" {
  url             = var.gitlab_url
  client_id_list  = [var.audience_value]
  thumbprint_list = [data.tls_certificate.gitlab_ci_oidc.certificates[0].sha1_fingerprint]
}

data "aws_iam_policy_document" "gitlab_ci_oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gitlab_ci_oidc.arn]
    }
  }

}

resource "aws_iam_policy" "gitlab_ci_oidc" {
  name = "gitlab_ci_oidc"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      },
    ]
  })
}

resource "aws_iam_role" "gitlab_ci_oidc" {
  name                = "GitLab_CI_OIDC"
  assume_role_policy  = data.aws_iam_policy_document.gitlab_ci_oidc.json
}

resource "aws_iam_role_policy_attachment" "gitlab_ci_oidc" {
  policy_arn = aws_iam_policy.gitlab_ci_oidc.arn
  role       = aws_iam_role.gitlab_ci_oidc.name
}
