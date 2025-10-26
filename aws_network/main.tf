# VPC Resource
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = var.default_tags
}

# Public Subnets (Using count to create multiple subnets from the list variable)
resource "aws_subnet" "public" {
  count = length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_cidr_blocks, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-public-subnet-${count.index + 1}"
    }
  )
}

# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.default_tags,
    {
      Name = "${var.prefix}-public-rt"
    }
  )
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
