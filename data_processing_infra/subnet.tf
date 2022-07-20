# Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "ap-northeast-2a"
    tags = { Name = "${var.pre_tag_name}-subnet-public" }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = { Name = "${var.pre_tag_name}-route-table-public" }
}

# public route table - public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# route table - internet gateway
resource "aws_route" "rt_igw" {
	route_table_id = aws_route_table.public.id
	gateway_id = aws_internet_gateway.igw.id
	destination_cidr_block = "0.0.0.0/0"
}

# Private Subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.16/28"
    availability_zone = "ap-northeast-2a"
    tags = { Name = "${var.pre_tag_name}-subnet-private" }
}

# Public Route Table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "${var.pre_tag_name}-route-table-private" }
}

# route table - private subnet
resource "aws_route_table_association" "subnet" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route" "rt_nat" {
    route_table_id = aws_route_table.public.id
	nat_gateway_id = aws_nat_gateway.nat_gateway.id
	destination_cidr_block = "0.0.0.0/0"
}

# NAT 용 elastic ip 생성
resource "aws_eip" "nat" {
    vpc = true  #생성 범위 지정
    tags = { Name = "${var.pre_tag_name}-elastic-ip-nat" }
}

# NAT
resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public.id
    tags = { Name = "${var.pre_tag_name}-nat-gateway" }
}
