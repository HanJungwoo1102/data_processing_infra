# VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/24"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = { Name = "${var.pre_tag_name}-vpc" }
}

# route table
resource "aws_default_route_table" "route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = { Name = "${var.pre_tag_name}-route-table" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "${var.pre_tag_name}-internet-gateway" }
}

# route table - internet gateway
resource "aws_route" "route" {
	route_table_id         = "${aws_vpc.vpc.default_route_table_id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = "${aws_internet_gateway.igw.id}"
}

# Elastic IP
resource "aws_eip" "elastic_ip" {
    vpc = true  #생성 범위 지정
    tags = { Name = "${var.pre_tag_name}-elastic-ip" }
}

# Subnet
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/28"
    availability_zone = "ap-northeast-2a"
    map_public_ip_on_launch = true
    tags = { Name = "${var.pre_tag_name}-subnet" }
}

resource "aws_route_table_association" "route_table_association" {
	subnet_id = aws_subnet.subnet.id
	route_table_id = aws_vpc.vpc.default_route_table_id
}

# Security Group
resource "aws_default_security_group" "default_security_group" {
    vpc_id = aws_vpc.vpc.id

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "${var.pre_tag_name}-default-security-group" }
}

# Default network access list
resource "aws_default_network_acl" "default" {
    default_network_acl_id = aws_vpc.vpc.default_network_acl_id
    subnet_ids = [aws_subnet.subnet.id]
    egress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    tags = { Name = "${var.pre_tag_name}-default-naetwork-access-list" }
}
