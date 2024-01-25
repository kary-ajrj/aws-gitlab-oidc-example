resource "aws_network_acl" "nacl_gitlab_aws_pipeline" {
  vpc_id = aws_vpc.vpc_gitlab_aws_pipeline.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }
}

resource "aws_network_acl_association" "main" {
  network_acl_id = aws_network_acl.nacl_gitlab_aws_pipeline.id
  subnet_id      = aws_subnet.subnet_aws_gitlab_pipeline.id
}
