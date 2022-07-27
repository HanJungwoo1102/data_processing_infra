resource "aws_instance" "data_management" {
    ami = var.ec2_config_data_management.ami
    instance_type = var.ec2_config_data_management.type
    subnet_id = aws_subnet.data_management_1.id

    # root disk
    root_block_device {
        volume_size           = var.ec2_config_data_management.root_volume_size
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true
    }
    # data disk
    ebs_block_device {
        device_name           = "/dev/sdb"
        volume_size           = var.ec2_config_data_management.ebs_volume_size
        volume_type           = "gp3"
        encrypted             = true
        delete_on_termination = true
    }
    
    iam_instance_profile = aws_iam_instance_profile.code_deploy_ec2.name
    vpc_security_group_ids = [aws_security_group.private_ec2.id]
    key_name = var.ec2_config_data_management.key_pair_name
    
    volume_tags = { Name = "${var.pre_tag_name}-ec2-volume-data-management" }
    tags = { Name = "${var.pre_tag_name}-ec2-data-management" }
}

// public
resource "aws_instance" "public" {
    ami = "ami-0fd0765afb77bcca7"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_default_security_group.vpc.id]
    associate_public_ip_address = true
    key_name = "jungwoohan-key-pair"
    tags = { Name = "${var.pre_tag_name}-ec2-public" }
}
