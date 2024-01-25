data "aws_ami" "launch_template_ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["launch-template-packer-ami"]
  }
}

resource "aws_launch_template" "lt_gitlab_aws_pipeline" {
  name_prefix   = "terraform-launch-template-gitlab-pipeline"
  image_id      = data.aws_ami.launch_template_ami.id
  instance_type = "t3a.medium"
  key_name      = "Gitlab-build-instance-key"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 16
      volume_type = "gp2"
    }
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    security_groups             = [aws_security_group.sg_gitlab_aws_pipeline.id]
    associate_public_ip_address = "true"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform-job-executor"
    }
  }
}

resource "aws_autoscaling_group" "asg_gitlab_aws_pipeline" {
  name                  = "terraform-asg-gitlab-pipeline"
  vpc_zone_identifier   = [aws_subnet.subnet_aws_gitlab_pipeline.id]
  desired_capacity      = 0
  max_size              = 2
  min_size              = 0
  protect_from_scale_in = true
  launch_template {
    id      = aws_launch_template.lt_gitlab_aws_pipeline.id
    version = aws_launch_template.lt_gitlab_aws_pipeline.latest_version
  }
}
