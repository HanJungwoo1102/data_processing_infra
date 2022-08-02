resource "aws_db_instance" "main" {
    identifier = "${var.pre_tag_name}-db"
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "8.0.28"
    instance_class       = "db.t3.medium"
    db_name              = var.db_config.db_name
    username             = var.db_config.username
    password             = var.db_config.password
    skip_final_snapshot  = true
    db_subnet_group_name = "${var.pre_tag_name}-subnet-group-db"
    vpc_security_group_ids = [aws_security_group.db.id]
    tags = { Name = "${var.pre_tag_name}-db-instance" }
}

resource "aws_db_subnet_group" "db" {
    name       = "${var.pre_tag_name}-subnet-group-db"
    subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]

    tags = { Name = "${var.pre_tag_name}-subnet-group-db" }
}
