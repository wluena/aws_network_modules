locals {
  // Standard name tag format: {namespace}-{stage}-{name}
  standard_name = "${var.namespace}-${var.stage}-${var.name}"

  // Define default tags that use the new convention
  default_tags = {
    Name        = local.standard_name
    Stage       = var.stage
    Namespace   = var.namespace
    ManagedBy   = "Terraform"
  }
}
# VPC Resource
resource "aws_vpc" "vpc" {
  cidr_block             = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = local.default_tags
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = local.default_tags
}

# Public Subnets (Using count to create multiple subnets from the list variable)
resource "aws_subnet" "public" {
  count = var.public_subnet_count # Corrected from 'length(var.public_cidr_blocks)'

  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  # CRITICAL FIX: Implement CIDR calculation
  # This calculates a /24 subnet (8 new bits) starting from index 0 of the main VPC CIDR.
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index) 

  tags = merge(
    local.default_tags,
    {
      "Name" = "${local.standard_name}-public-subnet-${count.index + 1}"
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
  tags = local.default_tags
}

# Route Table Association for Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}