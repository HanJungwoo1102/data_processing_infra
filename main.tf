module "data_processing_infra" {
    source = "./data_processing_infra"
    
    pre_tag_name = "jungwoohan"
    ec2_key_pair = "jungwoohan-key-pair"
    ec2_instance_config = {
        ami = "ami-0fd0765afb77bcca7"
        type = "t3.medium"
        root_volume_size = "50"
        ebs_volume_size = "128"
    }
    default_tags = {
        User = "jungwoo.han"
    }
    db_config = {
        db_name = var.db_config_db_name
        username = var.db_config_username
        password = var.db_config_password
    }
    availability_zone_1 = "ap-northeast-2a"
    availability_zone_2 = "ap-northeast-2b"
    subnet_cidr_blocks = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28", "10.0.0.48/28"]
}

variable "db_config_db_name" {
    type = string
}

variable "db_config_username" {
    type = string
}

variable "db_config_password" {
    type = string
}
