variable "aws_subnet_id" {

}

variable "vpc_id" {
  
}

variable "ecs_cluster_name" {
    type = string
    default = "test"
}

variable "ecr_repo_name" {
    type = string
    default = "test-repo"
}

variable "service_name" {
    type = string
    default = "my-ecs-service"
}

variable "role_arn" {
    default = "arn:aws:iam::381470515892:role/ecsTaskExecutionRole"
}