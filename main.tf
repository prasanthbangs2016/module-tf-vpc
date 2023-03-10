resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Roboshop-${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.subnets
  source   = "./subnets"
  name     = each.value["name"]
  subnets  = each.value["subnet_cidr"]
  vpc_id   = aws_vpc.main.id
  AZ       = var.AZ
  env      = "var.env"
  //ngw      = try(each.value["ngw"], false)
  //igw      = try(each.value["igw"], false)
  //igw_id   = aws_internet_gateway.igw.id
  //route_table = aws_route_table.route-tables
}

module "routes" {
  for_each = var.subnets
  source   = "./routes"
  vpc_id   = aws_vpc.main.id
  name = each.value["name"]
  subnet_ids = module.subnets
  gateway_id = aws_internet_gateway.igw.id
  nat_gateway_id = aws_nat_gateway.ngw.id
  ngw      = try(each.value["ngw"], false)
  igw      = try(each.value["igw"], false)
  default_vpc_cidr = var.default_vpc_cidr
  vpc_peering_connection_id =aws_vpc_peering_connection.peering-to-default-vpc.id

}

output "out" {
  value = module.subnets
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "Roboshop-${var.env}-igw"
  }
}


#resource "aws_route_table" "route-tables" {
#  for_each = var.subnets
#  vpc_id = aws_vpc.main.id
#
#  tags = {
#    Name = "Roboshop-Dev-${each.value["name"]}-rt"
#
#  }
#}
##way to create route table in general, it create multiple rt for all 3
##resource "aws_route" "public" {
##  route_table_id = aws_route_table.route-tables["public"].id
##  destination_cidr_block = "0.0.0.0/0"
##  gateway_id = aws_internet_gateway.igw.id
##}
##
##output "out" {
##  value = aws_route_table.route-tables
##  value = aws_route_table.route-tables["public"].id
##}
#
#resource "aws_route" "public" {
#  route_table_id = aws_route_table.route-tables["public"].id
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = aws_internet_gateway.igw.id
#}
#output "out" {
#  value = module.subnets["public"].out[*].id
#}
#
#resource "aws_route_table_association" "public" {
#  count = length(module.subnets["public"].out[*].id)
#  subnet_id      = element(module.subnets["public"].out[*].id, count.index )
#  route_table_id = aws_route_table.route-tables["public"].id
#}
#resource "aws_route" "private-apps" {
#  route_table_id = aws_route_table.route-tables["apps"].id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = aws_nat_gateway.ngw.id
#}
#
#resource "aws_route" "private-db" {
#  route_table_id = aws_route_table.route-tables["db"].id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id = aws_nat_gateway.ngw.id
#}
#
#
#resource "aws_route_table_association" "apps" {
#  count = length(module.subnets["apps"].out[*].id)
#  subnet_id      = element(module.subnets["apps"].out[*].id, count.index )
#  route_table_id = aws_route_table.route-tables["apps"].id
#}
#
#resource "aws_route_table_association" "db" {
#  count = length(module.subnets["db"].out[*].id)
#  subnet_id      = element(module.subnets["db"].out[*].id, count.index )
#  route_table_id = aws_route_table.route-tables["db"].id
#}
#
#
#
#eip is needed for nat gateway
resource "aws_eip" "ngw" {
  vpc      = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = module.subnets["public"].subnets[0].id

  tags = {
    Name = "gw NAT"
  }
#
#
}
#
resource "aws_vpc_peering_connection" "peering-to-default-vpc" {
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.default_vpc_id
  auto_accept = true

  tags = {
    Name = "Roboshop-${var.env}-to-default-aws-vpc"
  }
}


resource "aws_route" "peering-route-on-default-route-table" {
  route_table_id = var.default_route_table_id
  destination_cidr_block = var.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering-to-default-vpc.id
}

##add route53
resource "aws_route53_zone_association" "zone" {
  zone_id = data.aws_route53_zone.private.zone_id
  vpc_id  = aws_vpc.main.id
}
