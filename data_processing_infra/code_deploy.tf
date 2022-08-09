resource "aws_codedeploy_app" "data_management" {
    name = "${var.pre_tag_name}-code-deploy-app-data-management"
}

resource "aws_codedeploy_deployment_group" "data_management" {
    app_name              = aws_codedeploy_app.data_management.name
    deployment_group_name = "${var.pre_tag_name}-code-deploy-group-data-management"
    service_role_arn      = aws_iam_role.code_deploy.arn

    ec2_tag_set {
        ec2_tag_filter {
            type  = "KEY_AND_VALUE"
            key   = "Name"
            value = "${var.pre_tag_name}-ec2-data-management"
        }
    }
}

resource "aws_codedeploy_app" "api_server" {
    name = "${var.pre_tag_name}-code-deploy-app-api-server"
}

resource "aws_codedeploy_deployment_group" "api_server" {
    app_name              = aws_codedeploy_app.api_server.name
    deployment_group_name = "${var.pre_tag_name}-code-deploy-group-api-server"
    service_role_arn      = aws_iam_role.code_deploy.arn

    deployment_style {
        deployment_option = "WITH_TRAFFIC_CONTROL"
        deployment_type   = "BLUE_GREEN"
    }

    autoscaling_groups = [aws_autoscaling_group.api_server.name]

    load_balancer_info {
        target_group_info {
            name = aws_lb_target_group.asg_api_server.name
        }
    }
}
