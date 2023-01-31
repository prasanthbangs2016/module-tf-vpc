resource "aws_route_table" "route-tables" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Roboshop-Dev-${var.name}-rt"

  }
}

resource "aws_route_table_association" "assoc" {
  count = length(var.subnet_ids[var.name].out[*].id)
  subnet_id      = element(var.subnet_ids[var.name].out[*].id, count.index )
  route_table_id = aws_route_table.route-tables.id
}

#resource "aws_route_table_association" "assoc" {
#  count = length(var.subnet_ids[var.name].subnet_ids)
#  subnet_id      = element(var.subnet_ids[var.name].subnet_ids, count.index)
#  route_table_id = aws_route_table.route-tables.id
#}




#resource "aws_route" "public" {
#  count = var.name == var.igw ? 1 : 0
#  #count = var.name == "public" ? 1 : 0
#  route_table_id = aws_route_table.route-tables.id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = var.gateway_id
#}
#
#resource "aws_route" "private" {
#  count = var.name == var.ngw ? 1 : 0
#  #count = var.name == "private" ? 1 : 0
#  route_table_id = aws_route_table.route-tables.id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = var.nat_gateway_id
#}



#resource "aws_route" "public" {
#  route_table_id = aws_route_table.route-tables["public"].id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = aws_internet_gateway.igw.id
#}

#resource "aws_route" "private-apps" {
#  route_table_id = aws_route_table.route-tables["apps"].id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = aws_nat_gateway.ngw.id
#}

#resource "aws_route" "private-db" {
#  route_table_id = aws_route_table.route-tables["db"].id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = aws_nat_gateway.ngw.id
#}