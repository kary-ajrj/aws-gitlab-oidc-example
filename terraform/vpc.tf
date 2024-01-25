resource "aws_vpc" "vpc_gitlab_aws_pipeline" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}
