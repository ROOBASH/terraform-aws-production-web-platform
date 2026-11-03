output "application_url" {
  description = "HTTP URL of the application load balancer."
  value       = "http://${module.application.alb_dns_name}"
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer."
  value       = module.application.alb_dns_name
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets."
  value       = module.network.private_subnet_ids
}

output "autoscaling_group_name" {
  description = "Application Auto Scaling Group name."
  value       = module.application.autoscaling_group_name
}
