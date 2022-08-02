# AWS AutoScaling Group 생성
resource "aws_autoscaling_group" "api_server" {
    name = "${var.pre_tag_name}-asg-api-server"
    launch_template {
        id      = aws_launch_template.api_server.id
        version = "$Latest"
    }
    vpc_zone_identifier  = [aws_subnet.api_server_1.id, aws_subnet.api_server_2.id]

    ## target그룹 연결
    target_group_arns = [aws_lb_target_group.asg_api_server.arn]

    desired_capacity = 1
    min_size = 1
    max_size = 1

    tag {
        key = "Name"
        value = "${var.pre_tag_name}-asg-api-server"
        propagate_at_launch = false
    }
}
