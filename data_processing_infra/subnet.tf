# Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_block_public
    availability_zone = var.availability_zone_1
    tags = { Name = "${var.pre_tag_name}-subnet-public" }
}

# Public Route Table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    tags = { Name = "${var.pre_tag_name}-rtb-public" }
}

# route table - internet gateway
resource "aws_route" "rtb_igw" {
	route_table_id = aws_route_table.public.id
	gateway_id = aws_internet_gateway.igw.id
	destination_cidr_block = "0.0.0.0/0"
}

# public route table - public subnet
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# Private Subnet
resource "aws_subnet" "api_server_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_block_api_server_1
    availability_zone = var.availability_zone_1
    tags = { Name = "${var.pre_tag_name}-subnet-api-server-1" }
}
resource "aws_subnet" "api_server_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_block_api_server_2
    availability_zone = var.availability_zone_2
    tags = { Name = "${var.pre_tag_name}-subnet-api-server-2" }
}
resource "aws_subnet" "db_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_block_db_1
    availability_zone = var.availability_zone_1
    tags = { Name = "${var.pre_tag_name}-subnet-api-server-1" }
}
resource "aws_subnet" "db_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.subnet_cidr_block_db_2
    availability_zone = var.availability_zone_2
    tags = { Name = "${var.pre_tag_name}-subnet-api-server-2" }
}

# Private Route Table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "${var.pre_tag_name}-rtb-private" }
}

# private route table - nat gateway
resource "aws_route" "rtb_nat" {
    route_table_id = aws_route_table.private.id
	nat_gateway_id = aws_nat_gateway.nat_gw.id
	destination_cidr_block = "0.0.0.0/0"
}

# private route table - private subnet
resource "aws_route_table_association" "api_server_1" {
    subnet_id = aws_subnet.api_server_1.id
    route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "api_server_2" {
    subnet_id = aws_subnet.api_server_2.id
    route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "db_1" {
    subnet_id = aws_subnet.db_1.id
    route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "db_2" {
    subnet_id = aws_subnet.db_2.id
    route_table_id = aws_route_table.private.id
}

# NAT 용 elastic ip 생성
resource "aws_eip" "nat_gw" {
    vpc = true  #생성 범위 지정
    tags = { Name = "${var.pre_tag_name}-eip-nat-gw" }
}

# NAT
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_gw.id
    subnet_id = aws_subnet.public.id
    tags = { Name = "${var.pre_tag_name}-nat-gw" }
}
