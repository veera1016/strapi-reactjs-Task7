resource "aws_route53_record" "strapi" {
  zone_id = "Z06607023RJWXGXD2ZL6M"  # Replace with your Route 53 hosted zone ID
  name    = "togaruashok1996-api.contentecho.in"
  type    = "A"
  alias {
    name                   = aws_lb.strapi.dns_name
    zone_id                = aws_lb.strapi.zone_id
    evaluate_target_health = true
  }
}
