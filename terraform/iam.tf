resource "aws_iam_policy" "custom_iam_policy" {
  name   = "terraform-aws-gitlab-pipeline-iam-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup"
      ],
      "Resource": "${aws_autoscaling_group.asg_gitlab_aws_pipeline.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:GetPasswordData",
        "ec2-instance-connect:SendSSHPublicKey"
      ],
      "Resource": "arn:aws:ec2:ap-south-1:704973582740:instance/*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/aws:autoscaling:groupName": "terraform-asg-gitlab-pipeline"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_role_aws_gitlab_pipeline" {
  name               = "terraform-aws-gitlab-pipeline-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "custom_role_policy_attachment" {
  policy_arn = aws_iam_policy.custom_iam_policy.arn
  role       = aws_iam_role.iam_role_aws_gitlab_pipeline.name
}
