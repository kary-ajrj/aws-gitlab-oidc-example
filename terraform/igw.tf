resource "aws_internet_gateway" "gw_gitlab_aws_pipeline" {
  vpc_id = aws_vpc.vpc_gitlab_aws_pipeline.id
}
