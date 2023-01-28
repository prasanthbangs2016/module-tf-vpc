resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block

  tags = {
    Name = "Roboshop-${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.subnets
  source   = "./subnets"
  name     = each.value["name"]
  subnets  = each.value["subnet_cidr"]
  vpc_id   = var.vpc_id
  AZ       = var.AZ
  env      = "var.env"
  ngw      = try(each.value["ngw"], false)
  igw      = try(each.value["igw"], false)
  env      = var.env

}

resource "aws_internet_gateway" "igw" {
        vpc_id = var.vpc_id

        tags = {
          Name = "Roboshop-${var.env}-igw"
        }
      }


