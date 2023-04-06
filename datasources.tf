data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vmvpc.id]
  }
  tags = {
    Type = "public"
  }
  depends_on = [
    aws_subnet.subnets
  ]
}
data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vmvpc.id]
  }
  tags = {
    Type = "private"
  }
  depends_on = [
    aws_subnet.subnets
  ]
}