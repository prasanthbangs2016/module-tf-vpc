data "aws_route53_zone" "private" {
  name         = "roboshop.internal"
  private_zone = true
}

