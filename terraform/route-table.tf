resource "aws_route_table" "route_table_gitlab_aws_pipeline" {
  vpc_id = aws_vpc.vpc_gitlab_aws_pipeline.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_gitlab_aws_pipeline.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_aws_gitlab_pipeline.id
  route_table_id = aws_route_table.route_table_gitlab_aws_pipeline.id
}
