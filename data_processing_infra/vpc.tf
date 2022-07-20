# VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/24"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = { Name = "${var.pre_tag_name}-vpc" }
}

# Default Security Group
resource "aws_default_security_group" "public" {
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

    tags = { Name = "${var.pre_tag_name}-security-group-public" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = { Name = "${var.pre_tag_name}-internet-gateway" }
}

# # Default network access list
# resource "aws_default_network_acl" "default" {
#     default_network_acl_id = aws_vpc.vpc.default_network_acl_id
#     subnet_ids = [aws_subnet.public.id]
#     egress {
#         protocol   = -1
#         rule_no    = 100
#         action     = "allow"
#         cidr_block = "0.0.0.0/0"
#         from_port  = 0
#         to_port    = 0
#     }

#     ingress {
#         protocol   = -1
#         rule_no    = 100
#         action     = "allow"
#         cidr_block = "0.0.0.0/0"
#         from_port  = 0
#         to_port    = 0
#     }

#     tags = { Name = "${var.pre_tag_name}-network-acl" }
# }
