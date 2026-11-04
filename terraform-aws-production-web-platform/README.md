# Terraform AWS Production-Style Web Platform

A portfolio-ready Infrastructure as Code project that provisions a secure, highly available web tier on AWS.

## Architecture

- Custom VPC across two Availability Zones
- Two public subnets for an Application Load Balancer
- Two private subnets for an EC2 Auto Scaling Group
- Internet Gateway and one NAT Gateway for private outbound access
- Application Load Balancer with HTTP listener
- Launch Template using Amazon Linux 2023
- EC2 instances have no public IP and no inbound SSH
- Systems Manager access through an instance IAM role
- Security groups restrict traffic: Internet -> ALB -> application instances
- CloudWatch log group for application bootstrap logs
- Terraform outputs for the ALB DNS name and key infrastructure IDs

> Cost warning: NAT Gateway, ALB, and running EC2 instances incur charges. Deploy only when needed and run `terraform destroy` after practice. Check current AWS pricing for your region.

## Repository layout

```text
terraform-aws-production-web-platform/
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars.example
├── .gitignore
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── application/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── .github/workflows/terraform.yml
```

## Prerequisites

1. An AWS account and an IAM identity permitted to create VPC, EC2, ELB, IAM, Auto Scaling, CloudWatch and SSM resources.
2. AWS CLI configured locally (`aws configure` or an AWS SSO profile).
3. Terraform CLI (version 1.6 or newer).
4. A default VPC is not required; this project creates its own network.

Never commit AWS access keys, Terraform state, `.tfvars` files containing secrets, or plan files.

## Deploy

From this repository root:

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit the region, project name, and instance type if required.

aws sts get-caller-identity
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

After apply, Terraform prints the ALB URL. Open it in a browser. The first instance may take a few minutes to finish bootstrapping.

## Verify

```bash
terraform output
aws ec2 describe-instances --filters "Name=tag:Project,Values=terraform-web-platform"
```

The application instances are private. Use AWS Systems Manager Session Manager (after confirming the instance is online and the account has the required SSM permissions) rather than opening SSH.

## Destroy

```bash
terraform destroy
```

Review the destroy plan carefully. The NAT Gateway and load balancer are billable while provisioned.

## Remote state (recommended before team use)

This example uses local state so it is easy to start. For shared/team use, create an encrypted, versioned S3 bucket and configure an S3 backend with native lock files. Backend resources must exist before `terraform init`.

Example `backend.tf` (replace the bucket and key with your own unique values):

```hcl
terraform {
  backend "s3" {
    bucket       = "YOUR-UNIQUE-TERRAFORM-STATE-BUCKET"
    key          = "web-platform/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

After adding the backend configuration, migrate local state with:

```bash
terraform init -migrate-state
```

Do not put backend credentials in this file. Use an AWS profile, SSO, or workload identity.

## Project description

**Terraform AWS Production-Style Web Platform**
- Designed and provisioned a multi-AZ AWS network using Terraform modules, public/private subnets, route tables, an Internet Gateway and NAT Gateway.
- Deployed a private EC2 Auto Scaling Group behind an internet-facing Application Load Balancer.
- Implemented least-privilege instance access with IAM and AWS Systems Manager; avoided public SSH access.
- Added security-group traffic boundaries and CloudWatch log collection.
- Used Terraform variables, outputs, reusable modules, validation, and lifecycle workflows to make infrastructure repeatable.

Only list features you have personally deployed, tested, and can explain in an interview. Extend the project with HTTPS/ACM, WAF, remote state, CI/CD plan/apply approvals, alarms, and multi-environment workspaces as future enhancements.
