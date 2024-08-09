output "ecs_cluster_id" {
    value = module.ECS.ecs_cluster_id
}

output "ecr_repo_name" {
    value = module.ECS.ecr_repository_url
  
}

output "VPC_id" {
    value = module.VPC.vpc_id
}