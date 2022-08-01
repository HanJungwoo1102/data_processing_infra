module "data_processing_infra" {
    source = "./data_processing_infra"
    
    availability_zone_1 = "ap-northeast-2a"
    availability_zone_2 = "ap-northeast-2b"
    vpc_cidr_block = "10.0.0.0/24"
    subnet_cidr_block_public_1 = "10.0.0.0/28" 
    subnet_cidr_block_public_2 = "10.0.0.16/28"
    subnet_cidr_block_data_management_1 = "10.0.0.32/28"
    subnet_cidr_block_api_server_1 = "10.0.0.48/28"
    subnet_cidr_block_api_server_2 = "10.0.0.64/28"
    subnet_cidr_block_db_1 = "10.0.0.80/28"
    subnet_cidr_block_db_2 = "10.0.0.96/28"
    
    ec2_config_data_management = {
        key_pair_name = "jungwoohan-key-pair"
        ami = "ami-0fd0765afb77bcca7"
        type = "t3.medium"
        root_volume_size = "50"
        ebs_volume_size = "128"
    }
    db_config = {
        db_name = var.db_config_db_name
        username = var.db_config_username
        password = var.db_config_password
    }

    github_name = "sunrisehouse"
    github_repository_api_server = {
        name = "lgcns_api_server"
        branch = "main"
    }
    github_repository_data_management = {
        name = "lgcns_data_manager"
        branch = "main"
    }

    pre_tag_name = "jungwoohan"
    default_tags = {
        User = "jungwoo.han"
    }
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
