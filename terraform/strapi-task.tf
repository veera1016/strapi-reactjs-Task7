resource "aws_ecs_task_definition" "strapi" {
  family                = "strapi-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "veera1016/strapidocker:latest"  # Replace with your Strapi image URL
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
    }
  ])
}

