resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr_blocks
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "my-vpc"
    }
}
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = var.subnet_cidr_blocks
    map_public_ip_on_launch = true
    tags = {
      Name = "subnet-my-vpc"
    }
}


resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
      Name = "gateway"
    }
}


resource "aws_route_table" "route_table1" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
      Name = "route_table1"
    }
}

resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.route_table1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}


resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.route_table1.id
}


#For Private Subnet 
# Private Subnet
# resource "aws_subnet" "private_subnet_1" {
#   vpc_id     = aws_vpc.my-vpc.id
#   cidr_block = var.private_subnet_cidr_blocks
#   tags = {
#     Name = "private-subnet-1-my-vpc"
#   }
# }

# # Route Table for Private Subnet (Optional: Add routes to NAT Gateway if needed)
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.my-vpc.id
#   tags = {
#     Name = "private_route_table"
#   }
# }

# # Associate Private Subnet with Private Route Table
# resource "aws_route_table_association" "private_subnet_assoc" {
#   subnet_id      = aws_subnet.private_subnet_1.id
#   route_table_id = aws_route_table.private_route_table.id
# }