resource "aws_ecs_service" "reactjs" {
  name            = "reactjs-service"
  cluster         = aws_ecs_cluster.strapi.id
  task_definition = aws_ecs_task_definition.reactjs.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  network_configuration {
    subnets          = ["<YOUR_SUBNET_ID>"]  # Replace with your subnet IDs
    security_groups  = ["<YOUR_SECURITY_GROUP_ID>"]  # Replace with your security group ID
    assign_public_ip = true
  }

  tags = {
    Name = "reactjs-service"
  }
}
