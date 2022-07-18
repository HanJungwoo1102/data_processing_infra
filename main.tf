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
}