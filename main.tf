module "VPC"{
  source = "./modules/VPC"
}


module "ECS" {
  source = "./modules/ECS"
  aws_subnet_id = module.VPC.aws_subnet_id
  vpc_id = module.VPC.vpc_id  
}