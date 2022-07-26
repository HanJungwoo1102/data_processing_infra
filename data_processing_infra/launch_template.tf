resource "aws_launch_template" "api_server" {
    name = "${var.pre_tag_name}-launch-template-api-server"

    block_device_mappings {
        device_name = "/dev/sdb"

        ebs {
            volume_size = var.ec2_config_data_management.root_volume_size
        }
    }

    image_id = var.ec2_config_data_management.ami

    instance_type = var.ec2_config_data_management.type

    key_name = var.ec2_config_data_management.key_pair_name

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "${var.pre_tag_name}-ec2-api-server"
        }
    }

    tags = { Name = "${var.pre_tag_name}-launch-template-api-server" }
}