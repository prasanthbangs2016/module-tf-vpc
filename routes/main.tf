resource "aws_route_table" "route-tables" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-Dev-${var.name}-rt"

  }
}