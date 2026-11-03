variable "aws_region" {
  description = "AWS region in which to deploy the platform."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Short project name used in resource names and tags."
  type        = string
  default     = "terraform-web-platform"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Two public subnet CIDR blocks, one per AZ."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDRs."
  }
}

variable "private_subnet_cidrs" {
  description = "Two private subnet CIDR blocks, one per AZ."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDRs."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the application Auto Scaling Group."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of application instances."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Initial desired number of application instances."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of application instances."
  type        = number
  default     = 3
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to reach the public HTTP load balancer. Use a narrower range where possible."
  type        = string
  default     = "0.0.0.0/0"
}
