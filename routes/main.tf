resource "aws_route_table" "route-tables" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-Dev-${var.name}-rt"

  }
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_ids[var.name].out[*].id)
  subnet_id      = element(var.subnet_ids[var.name].out[*].id, count.index )
  route_table_id = aws_route_table.route-tables.id
}