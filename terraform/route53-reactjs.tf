resource "aws_route53_record" "reactjs" {
  zone_id = "<YOUR_ROUTE53_ZONE_ID>"  # Replace with your Route 53 hosted zone ID
  name    = "yourname.contentecho.in"
  type    = "A"
  alias {
    name                   = aws_lb.reactjs.dns_name
    zone_id                = aws_lb.reactjs.zone_id
    evaluate_target_health = true
  }
}