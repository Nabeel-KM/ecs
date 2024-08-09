output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.my_cluster.id
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.my_ecr_repo.repository_url
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.my_service.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.my_task.arn
}