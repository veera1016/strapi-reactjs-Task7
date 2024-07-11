provider "aws" {
  region = "ca-central-1"
}

# VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

data "aws_availability_zones" "available" {}

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

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "my-cluster"
}

# ECS Task Definitions
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

# ECS Services
resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.allow_all.id]
  }
}

resource "aws_ecs_service" "react" {
  name            = "react-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.react.arn
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.allow_all.id]
  }
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = "contentecho.in"
}

# Route 53 DNS Records (Placeholders for IPs)
resource "aws_route53_record" "strapi" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996-api.contentecho.in"
  type    = "A"
  ttl     = 300
  records = ["<DYNAMIC_PUBLIC_IP>"]  # Replace with actual IP or use a script to update it
}

resource "aws_route53_record" "react" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996.contentecho.in"
  type    = "A"
  ttl     = 300
  records = ["<DYNAMIC_PUBLIC_IP>"]  # Replace with actual IP or use a script to update it
}

# Example null_resource to run an external script (optional)
resource "null_resource" "update_ips" {
  provisioner "local-exec" {
    command = "python update_route53_records.py"  # Ensure this path is correct
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
