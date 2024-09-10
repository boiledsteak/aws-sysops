resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}

# Define the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "my-internet-gateway"
  }
}

# Define the Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the Route Table with Public Subnets
resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public.id
}


# create NAT gateway to public-1a subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-1a.id

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}


# create route table for private subnets to route internet traffic to the NAT gateway
# Private subnet route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# Associate the route table with the private subnets
resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private.id
}


# create the subnets
resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-1a"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "private-1a"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1b"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "private-1b"
  }
}