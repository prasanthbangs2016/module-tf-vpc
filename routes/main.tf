resource "aws_route_table" "route-tables" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name}-rt"
  }
}

resource "aws_route_table_association" "assoc" {
  count          = length(var.subnet_ids[var.name].subnet_ids)
  subnet_id      = element(var.subnet_ids[var.name].subnet_ids, count.index)
  route_table_id = aws_route_table.route-tables.id
}


resource "aws_route" "public" {
  count                  = var.igw ? 1 : 0
  route_table_id         = aws_route_table.route-tables.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.gateway_id
}


resource "aws_route" "private" {
  count                  = var.ngw ? 1 : 0
  route_table_id         = aws_route_table.route-tables.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route" "peering" {
  route_table_id            = aws_route_table.route-tables.id
  destination_cidr_block    = var.default_vpc_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}