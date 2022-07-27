resource "aws_instance" "data_management" {
    ami = var.ec2_config_data_management.ami
    instance_type = var.ec2_config_data_management.type
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.private_ec2.id]
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
    key_name = var.ec2_config_data_management.key_pair_name
    tags = { Name = "${var.pre_tag_name}-ec2-data-management" }
}

resource "aws_eip" "data_management" {
    vpc = true  #생성 범위 지정
    tags = { Name = "${var.pre_tag_name}-eip-data-management" }
}

resource "aws_eip_association" "data_management" {
    instance_id   = aws_instance.data_management.id
    allocation_id = aws_eip.data_management.id
}
