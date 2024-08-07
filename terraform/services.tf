resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true  # Ensure this is set correctly
  }

  launch_type = "FARGATE"  # Ensure the launch type is correctly set to FARGATE
}

resource "aws_ecs_service" "react" {
  name            = "react-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.react.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true  # Ensure this is set correctly
  }

  launch_type = "FARGATE"  # Ensure the launch type is correctly set to FARGATE
}

resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true  # Ensure this is set correctly
  }

  launch_type = "FARGATE"  # Ensure the launch type is correctly set to FARGATE
}
