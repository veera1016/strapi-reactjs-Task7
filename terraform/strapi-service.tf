resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = ["subnet-00ecabcdee68011aa"]  # Replace with your subnet IDs
    security_groups  = ["sg-09a727a76e975af3a"]  # Replace with your security group ID
    assign_public_ip = true
  }

  tags = {
    Name = "strapi-service"
  }
}
