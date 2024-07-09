resource "aws_ecs_task_definition" "reactjs" {
  family                = "reactjs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "reactjs"
      image     = "veera1016/strapidocker:latest"  # Replace with your ReactJS image URL
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
