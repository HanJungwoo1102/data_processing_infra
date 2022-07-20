resource "aws_instance" "ec2_instance" {
    ami = var.ec2_instance_config.ami
    instance_type = var.ec2_instance_config.type
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_default_security_group.default.id]
    # root disk
    root_block_device {
        volume_size           = var.ec2_instance_config.root_volume_size
        volume_type           = "gp2"
        encrypted             = true
        delete_on_termination = true
    }
    # data disk
    ebs_block_device {
        device_name           = "/dev/sdb"
        volume_size           = var.ec2_instance_config.ebs_volume_size
        volume_type           = "gp3"
        encrypted             = true
        delete_on_termination = true
    }
    key_name = "${var.ec2_key_pair}"
    tags = { Name = "${var.pre_tag_name}-ec2-instance" }
}

resource "aws_eip" "ec2_instance" {
    vpc = true  #생성 범위 지정
    tags = { Name = "${var.pre_tag_name}-eip-ec2-instance" }
}

resource "aws_eip_association" "ec2_instance" {
    instance_id   = aws_instance.ec2_instance.id
    allocation_id = aws_eip.ec2_instance.id
}