resource "aws_ecs_task_definition" "reactjs" {
  family                = "reactjs-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "reactjs"
      image     = "<YOUR_REACTJS_IMAGE>"  # Replace with your ReactJS image URL
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
