resource "aws_subnet" "main" {
  count = length(var.subnets)
  vpc_id     = var.vpc_id
  cidr_block = var.subnets[count.index]
  availability_zone_id = var.AZ[count.index]

  tags = {
    Name = "Roboshop-${var.name}-snet"
  }
}
