resource "aws_db_instance" "db_instance" {
    identifier = "${var.pre_tag_name}-db-instance"
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "8.0.28"
    instance_class       = "db.t3.micro"
    db_name              = var.db_config.db_name
    username             = var.db_config.username
    password             = var.db_config.password
    skip_final_snapshot  = true
    db_subnet_group_name = "${var.pre_tag_name}-subnet-group-private"
    vpc_security_group_ids = [aws_security_group.db.id]
    tags = { Name = "${var.pre_tag_name}-db-instance" }
}

resource "aws_db_subnet_group" "private" {
    name       = "${var.pre_tag_name}-subnet-group-private"
    subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

    tags = { Name = "${var.pre_tag_name}-subnet-group-private" }
}

resource "aws_security_group" "db" {
    name        = "db-security-group"
    description = "db security group"
    vpc_id = aws_vpc.vpc.id
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        cidr_blocks = [var.subnet_cidr_blocks[0]]
    }
    # Allow all outbound traffic.
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = { Name = "${var.pre_tag_name}-security-group-db" }
}
