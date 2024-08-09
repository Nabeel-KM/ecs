# Create an ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = var.ecs_cluster_name
}

# Create an ECR Repository
resource "aws_ecr_repository" "my_ecr_repo" {
  name = var.ecr_repo_name
  image_tag_mutability = "MUTABLE"
  force_delete = true
}

# Ansible Playbook execution using local-exec provisioner
resource "null_resource" "ansible_push_to_ecr" {
  provisioner "local-exec" {
    working_dir = "/home/nabeel-sarfraz/testDocker"
    # command = "ansible-playbook push_docker_image.yml --extra-vars "ecr_url=${aws_ecr_repository.my_ecr_repo.repository_url} ecr_image_name=test-repo""
    
    command = <<EOT
      ansible-playbook push_docker_image.yml --extra-vars "ecr_url=${aws_ecr_repository.my_ecr_repo.repository_url} ecr_image_name=test-repo"
    EOT
  }

  depends_on = [aws_ecr_repository.my_ecr_repo]
}

# Create an ECS Task Definition
resource "aws_ecs_task_definition" "my_task" {
  family                   = "my-task-family"
  container_definitions    = jsonencode([{
    name        = "my-container"
    image       = "${aws_ecr_repository.my_ecr_repo.repository_url}:latest"
    memory      = 512
    cpu         = 256
    essential   = true
    portMappings = [{
      containerPort = 5000
      hostPort      = 5000
    }]
  }])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = var.role_arn
  task_role_arn            = var.role_arn
}

# Create IAM Role for ECS Task
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "ecs-tasks.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# Create a Security Group
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow traffic to ECS service"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ECS Service
resource "aws_ecs_service" "my_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.aws_subnet_id]
    security_groups = [aws_security_group.ecs_service_sg.id]
    assign_public_ip = true
  }

  depends_on = [null_resource.ansible_push_to_ecr]
}


