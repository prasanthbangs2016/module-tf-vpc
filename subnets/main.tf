resource "aws_subnet" "main" {
  count = length(var.subnets)
  vpc_id     = var.vpc_id
  cidr_block = var.subnets[count.index]
  availability_zone = var.AZ[count.index]

  tags = {
    Name = "Roboshop-${var.name}-snet"
  }
}

output "out" {
  value = aws_subnet.main
}

output "subnets" {
  value = aws_subnet.main
}

output "subnet_ids" {
  value = [for s in aws_subnet.main : s.id]
}