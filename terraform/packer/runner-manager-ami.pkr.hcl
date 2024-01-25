packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "AWSAccessKeyID" {}
variable "AWSSecretAccessKey" {}
variable "GitlabRunnerToken" {}

source "amazon-ebs" "ubuntu" {
  ami_name      = "gitlab-runner-manager-packer-ami"
  instance_type = "t2.nano"
  region        = "<VALUE>"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "runner-manager-ami-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "privateKey.pem"
    destination = "~/.ssh/key.pem"
  }
  provisioner "shell" {
    inline = [
      "chmod 400 ~/.ssh/key.pem"
    ]
  }

  provisioner "shell" {
    script = "install-docker.sh"
  }
  provisioner "shell" {
    script = "install-gitlab-runner.sh"
  }
  provisioner "shell" {
    script = "install-fleeting-plugin-aws.sh"
  }

  provisioner "shell" {
    inline = [
      "mkdir ~/.aws"
    ]
  }
  provisioner "file" {
    source      = "aws-config"
    destination = "~/.aws/config"
  }
  provisioner "file" {
    source      = "aws-creds"
    destination = "~/.aws/credentials"
  }
  provisioner "shell" {
    inline = [
      "sed -i 's|aKeyID|${var.AWSAccessKeyID}|' ~/.aws/credentials",
      "sed -i 's|aSecretAccessKey|${var.AWSSecretAccessKey}|' ~/.aws/credentials"
    ]
  }

  provisioner "file" {
    source      = "config.toml"
    destination = "~/config.toml"
  }
  provisioner "shell" {
    inline = [
      "sudo mv ~/config.toml /etc/gitlab-runner/config.toml",
      "sudo sed -i 's|aRunnerToken|${var.GitlabRunnerToken}|' /etc/gitlab-runner/config.toml"
    ]
  }
}
