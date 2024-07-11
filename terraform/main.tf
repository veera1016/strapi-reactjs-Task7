provider "aws" {
  region = "ca-central-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = element(local.azs, count.index)
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "strapi"
    image     = "veera1016/strapidocker:latest"
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
    }]
  }])
}

resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "react" {
  family                   = "react"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "react"
    image     = "veera1016/reactjsdocker:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_ecs_service" "react" {
  name            = "react-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.react.arn
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.allow_all.id]
    assign_public_ip = true
  }
}

resource "aws_route53_zone" "main" {
  name = "contentecho.in"
}

resource "aws_route53_record" "strapi" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996-api.contentecho.in"
  type    = "A"
  ttl     = 300
  records = [aws_ecs_service.strapi.network_configuration[0].assign_public_ip]
}

resource "aws_route53_record" "react" {
  zone_id = Z06607023RJWXGXD2ZL6M
  name    = "togaruashok1996.contentecho.in"
  type    = "A"
  ttl     = 300
  records = [aws_ecs_service.react.network_configuration[0].assign_public_ip]
}
