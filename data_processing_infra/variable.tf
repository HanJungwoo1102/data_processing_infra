variable pre_tag_name {
    type = string
}

variable default_tags {
    type = map(string)
}

variable ec2_config_data_management {
    type = map(string)
}

variable db_config {
    type = map(string)
}

variable availability_zone_1 {
    type = string
}

variable availability_zone_2 {
    type = string
}

variable vpc_cidr_block {
    type = string
}

variable subnet_cidr_block_public_1 {
    type = string
}

variable subnet_cidr_block_public_2 {
    type = string
}

variable subnet_cidr_block_data_management_1 {
    type = string
}

variable subnet_cidr_block_api_server_1 {
    type = string
}

variable subnet_cidr_block_api_server_2 {
    type = string
}

variable subnet_cidr_block_db_1 {
    type = string
}

variable subnet_cidr_block_db_2 {
    type = string
}
