module "s3" {
  source = "../modules/s3"
  bucket_name = var.bucket_name
}

output "s3_bucket_name" {
  value       = module.s3.s3_bucket_name
}

module "vpc" {
  source                = "../modules/vpc"
  cidr_block            = var.cidr_block
  project-name          = var.project-name
}

output "project-name" {
  value = module.vpc.project-name
}

output "vpc-id" {
  value = module.vpc.vpc-id
}

output "subnet-ids" {
  value = module.vpc.subnet-ids
}


module "sg" {
  source                = "../modules/sg"
  project-name          = var.project-name
  vpc-id                = module.vpc.vpc-id
}

output "public-instance-sg-id" {
  value = module.sg.public-instance-sg-id
}

output "elb-sg-id" {
  value = module.sg.elb-sg-id
}

module "ec2" {
  source                = "../modules/ec2"
  project-name          = var.project-name
  instance_type         = var.instance_type
  subnet_ids            = [module.vpc.subnet-ids[0], module.vpc.subnet-ids[1], module.vpc.subnet-ids[2]]
  public-instance-sg-id = module.sg.public-instance-sg-id
}

output "exported_ips" {
  value = module.ec2.exported_ips
}

output "instance_ids" {
  value = module.ec2.instance_ids
}

module "elb" {
  source                = "../modules/elb"
  project-name          = var.project-name
  subnet-ids            = [module.vpc.subnet-ids[0], module.vpc.subnet-ids[1], module.vpc.subnet-ids[2]]
  elb-sg-id             = module.sg.elb-sg-id
  vpc-id                = module.vpc.vpc-id
  domain-name           = var.domain-name
  subdomain-name        = var.subdomain-name
  instance_ids          = module.ec2.instance_ids
}

output "elb-arn" {
  value = module.elb.elb-arn
}

output "elb-dns-name" {
  value = module.elb.elb-dns-name
}