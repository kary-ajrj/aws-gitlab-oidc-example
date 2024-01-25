resource "aws_subnet" "subnet_aws_gitlab_pipeline" {
  vpc_id            = aws_vpc.vpc_gitlab_aws_pipeline.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "<VALUE>"
}
