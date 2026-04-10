provider "aws" {
  region = "us-east-1"

}
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/24"
  instance_tenancy = "default"
  tags = {
    Name = "real-project"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/27"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/27"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public2"
 }
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.64/27"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.96/27"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private2"
  }
}
resource "aws_subnet" "private1-db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.128/27"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private1-db"
  }
}
resource "aws_subnet" "private2-db" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.160/27"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private2-db"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "public"
  }
}
resource "aws_route_table" "private-route1" {
  vpc_id = aws_vpc.main.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
  tags = {
    Name = "private1"
  }
}
resource "aws_route_table" "private-route2" {
  vpc_id = aws_vpc.main.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat2.id
  }
  tags = {
    Name = "private2"
  }
}
resource "aws_route_table_association" "association3" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private-route1.id
}
resource "aws_route_table_association" "association5" {
  subnet_id      = aws_subnet.private1-db.id
  route_table_id = aws_route_table.private-route1.id
}

resource "aws_route_table_association" "association4" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private-route2.id
}
resource "aws_route_table_association" "association6" {
  subnet_id      = aws_subnet.private2-db.id
  route_table_id = aws_route_table.private-route2.id
}




resource "aws_route_table_association" "association1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.example.id
}
resource "aws_route_table_association" "association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.example.id
}
resource "aws_eip" "lb1" {
  domain   = "vpc"
}
resource "aws_eip" "lb2" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.lb1.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "gw NAT1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.lb2.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "gw NAT2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}