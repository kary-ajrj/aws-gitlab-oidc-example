# gitlab-aws-pipeline-infra-example
- Execute in the sequence mentioned below.

## OIDC for CI
To run pipelines, we are using OIDC in all AWS accounts.
Possible values for the backend bucket are : `<value 1>`,`<value 2>`,`<value 3>`.
```
export AWS_ACCESS_KEY_ID= **** 
export AWS_SECRET_ACCESS_KEY= ****
export AWS_SESSION_TOKEN=****
cd terraform/oidc
terraform init \ 
-backend-config="bucket=<>"
terraform apply
```

## Create CLI user
`gitlab-runner` plugin needs it to talk to ASG.
```
cd terraform/cli-user
terraform init -reconfigure
terraform apply
```

## Packer for 2 AMIs
- `packer` directory has 2 `*.pkr.hcl` files to create AMIs for runner manager and job executor EC2 instances.
- Pre-requisite is that you need the key pair named `<value>`.
```
cd terraform/packer
packer build -var-file=variableValues.json runner-manager-ami.pkr.hcl
packer build lanuch-template-ami.pkr.hcl
```
- The generated AMIs are fetched in the `ec2.tf` and `asg.tf` files respectively. 
- The `variableValues.json` and `key.pem` containing secrets are in `.gitignore`, hence not committed.
  - Sample has been provided with notes for `variableValues.json`.
  - `privateKey.pem` is for key named `<value>`.

## Create the infrastructure
```
cd ..
terraform init -reconfigure
terraform apply
```

***

## Note
- 1 key pair and master S3 bucket for storing the state files, have been manually created.
- The AMI for EC2 instance acting as runner manager, has a /etc/gitlab-runner/config.toml. In this, the name of the ASG is hard-coded.
