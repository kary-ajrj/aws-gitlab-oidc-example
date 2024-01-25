data "aws_ami" "runner_manager_ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["gitlab-runner-manager-packer-ami"]
  }
}

resource "aws_instance" "ec2_gitlab_aws_pipeline" {
  ami                         = data.aws_ami.runner_manager_ami.id
  instance_type               = "t3a.nano"
  subnet_id                   = aws_subnet.subnet_aws_gitlab_pipeline.id
  vpc_security_group_ids      = [aws_security_group.sg_gitlab_aws_pipeline.id]
  key_name                    = "Gitlab-Runner-Manager-Key"
  associate_public_ip_address = true
  monitoring                  = true
  tags                        = {
    Name = "terraform-gitlab-runner-manager"
  }
  metadata_options {
    http_tokens = "required"
  }
}
