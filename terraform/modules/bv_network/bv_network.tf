data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = ["${var.bv_vpc_id}"]
  }
}

// public subnets
resource "aws_subnet" "public" {
  vpc_id                  = var.bv_vpc_id
  count                   = var.num_of_public_subnets
  cidr_block              = element(var.subnets_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name: "${var.name}-${var.environment}-public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

// private subnets
resource "aws_subnet" "private" {
  vpc_id                  = var.bv_vpc_id
  count                   = var.num_of_private_subnets
  cidr_block              = element(var.subnets_cidrs, count.index+var.num_of_public_subnets)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name: "${var.name}-${var.environment}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}


// internet gateway
resource "aws_internet_gateway" "igw" {

  count = var.create_igw ? 1 : 0

  vpc_id         = var.bv_vpc_id

  tags = { 
  	Name: "igw-${var.name}-${var.environment}"
  }
  
}

//route table for public subnets
resource "aws_route_table" "public" {
  vpc_id         = var.bv_vpc_id

  route {
    cidr_block   = "0.0.0.0/0"
    gateway_id   = data.aws_internet_gateway.default.internet_gateway_id
    #gateway_id   = aws_internet_gateway.igw.id
  }

  tags = {
    Name: "rt-${var.name}-public"
  }
}

//route table for private subnets
resource "aws_route_table" "private" {
  vpc_id         = var.bv_vpc_id

  tags = {
    Name: "rt-${var.name}-private"
  }
}

//route table associations for subnets
resource "aws_route_table_association" "public" {
  count          = var.num_of_public_subnets
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.num_of_private_subnets
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


