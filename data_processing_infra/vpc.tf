# VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = { Name = "${var.pre_tag_name}-vpc" }
}

# Default Security Group
resource "aws_default_security_group" "vpc" {
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

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "${var.pre_tag_name}-security-group-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "${var.pre_tag_name}-igw" }
}

# Default network access list
resource "aws_default_network_acl" "default" {
    default_network_acl_id = aws_vpc.vpc.default_network_acl_id
    subnet_ids = []
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

    tags = { Name = "${var.pre_tag_name}-network-acl-default" }
}

resource "aws_default_route_table" "default" {
    default_route_table_id = aws_vpc.vpc.default_route_table_id

    tags = { Name = "${var.pre_tag_name}-rtb-default" }
}

# security group
resource "aws_security_group" "alb" {
    name = "${var.pre_tag_name}-security-group-alb"
    description = "alb security group"
    vpc_id = aws_vpc.vpc.id

    ## 인바운드 HTTP 트래픽 허용
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    ## 모든 아웃바운드 트래픽을 허용
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "${var.pre_tag_name}-security-group-alb" }
}

resource "aws_security_group" "private_ec2" {
    name        = "${var.pre_tag_name}-security-group-private-ec2"
    description = "ec2 security group"
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = { Name = "${var.pre_tag_name}-security-group-private-ec2" }
}

resource "aws_security_group" "db" {
    name        = "${var.pre_tag_name}-security-group-db"
    description = "db security group"
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks = [var.vpc_cidr_block]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = { Name = "${var.pre_tag_name}-security-group-db" }
}
