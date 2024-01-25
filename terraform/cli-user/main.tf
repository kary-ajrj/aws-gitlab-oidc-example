provider "aws" {
  region = "<VALUE>"
}

resource "aws_iam_user" "cli-user" {
  name = "terraform-gitlab-pipeline-cli-user"
  tags = {
    description = "gitlab-runner-manager-to-ASG"
  }
}

resource "aws_iam_access_key" "cli-user" {
  user = aws_iam_user.cli-user.name
}

data "aws_iam_policy_document" "cli-user" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "cli-user" {
  name   = "gitlab-runner-manager-to-ASG"
  user   = aws_iam_user.cli-user.name
  policy = data.aws_iam_policy_document.cli-user.json
}
