resource "aws_launch_template" "api_server" {
    name = "${var.pre_tag_name}-launch-template-api-server"
    image_id = var.ec2_config_data_management.ami
    instance_type = var.ec2_config_data_management.type
    key_name = var.ec2_config_data_management.key_pair_name
    block_device_mappings {
        device_name = "/dev/sdb"
        ebs { volume_size = var.ec2_config_data_management.root_volume_size }
    }

    iam_instance_profile {
        name = aws_iam_instance_profile.code_deploy_ec2.name
    }
    vpc_security_group_ids = [aws_security_group.private_ec2.id]

    tag_specifications {
        resource_type = "instance"
        tags = { Name = "${var.pre_tag_name}-ec2-api-server" }
    }

    tag_specifications {
        resource_type = "volume"
        tags = { Name = "${var.pre_tag_name}-ec2-volume-api-server" }
    }

    tag_specifications {
        resource_type = "network-interface"
        tags = { Name = "${var.pre_tag_name}-ec2-network-interface-api-server" }
    }

    user_data = filebase64("scripts/initialize_ec2_instance.sh")

    tags = { Name = "${var.pre_tag_name}-launch-template-api-server" }
}
