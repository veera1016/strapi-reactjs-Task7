resource "aws_route53_zone" "main" {
  name = "contentecho.in"
}

resource "aws_route53_record" "strapi" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996-api.contentecho.in"
  type    = "A"
  ttl     = 300
  records = [aws_ecs_service.nginx.network_configuration[0].assign_public_ip]  # To be updated with actual IP
}

resource "aws_route53_record" "react" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996.contentecho.in"
  type    = "A"
  ttl     = 300
  records = [aws_ecs_service.nginx.network_configuration[0].assign_public_ip]  # To be updated with actual IP
}
