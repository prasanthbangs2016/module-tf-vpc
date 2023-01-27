resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block

  tags = {
    Name = "Roboshop-${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.subnets
  source = "./subnets"
  name = each.value["name"]
  subnets = each.value["subnet_cidr"]
  vpc_id = aws_vpc.main.id
  AZ = var.AZ

}