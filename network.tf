resource "aws_vpc" "vmvpc" {
  cidr_block = var.vpc_info
  tags = {
    Name = "vmvpc"
  }
}

resource "aws_subnet" "subnets" {
  vpc_id            = aws_vpc.vmvpc.id
  count             = length(var.subnet_info.names)
  cidr_block        = cidrsubnet(var.vpc_info, 8, count.index)
  availability_zone = "${var.region}${var.subnet_info.zones[count.index % 2]}"
  tags = {
    "Name" = var.subnet_info.names[count.index],
    Env    = terraform.workspace
    Type   = contains(var.subnet_info.public_subnets, var.subnet_info.names[count.index]) ? "public" : "private"

  }
  depends_on = [
    aws_vpc.vmvpc
  ]
}
resource "aws_internet_gateway" "vmvpc_igw" {
  vpc_id = aws_vpc.vmvpc.id
  tags = {
    "Name" = "vmvpc_igw"
  }
  depends_on = [
    aws_vpc.vmvpc
  ]
}
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vmvpc.id
  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.vmvpc_igw.id
  }
  tags = {
    "Name" = "publicRT"
  }
  depends_on = [
    aws_internet_gateway.vmvpc_igw
  ]
}
resource "aws_route_table_association" "publicRT_Assoc" {
  route_table_id = aws_route_table.publicRT.id
  count          = length(var.subnet_info.public_subnets)
  subnet_id      = data.aws_subnets.public_subnets.ids[count.index]
  depends_on = [
    data.aws_subnets.private_subnets,
    data.aws_subnets.public_subnets,
    aws_subnet.subnets
  ]
}
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vmvpc.id
  tags = {
    "Name" = "privateRT"
  }
}

