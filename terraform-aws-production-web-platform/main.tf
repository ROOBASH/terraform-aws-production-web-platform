data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "./modules/security"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  allowed_http_cidr = var.allowed_http_cidr
}

module "application" {
  source = "./modules/application"

  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  instance_type      = var.instance_type
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
}
