resource "aws_lb" "api_server" {
    name               = "${var.pre_tag_name}-alb-api-server"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

    tags = { Name = "${var.pre_tag_name}-alb-api-server" }
}

# ALB 타겟그룹 생성
resource "aws_lb_target_group" "asg_api_server" {
    name     = "${var.pre_tag_name}-albtg-api-server"
    port     = var.web_server_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id

    health_check {
        path                = "/health"
        port                = var.web_server_port
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = { Name = "${var.pre_tag_name}-albtg-api-server" }
}

# ALB aws_lb_listener 생성
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.api_server.arn
    port              = 80
    protocol          = "HTTP"
    ## 기본값으로 단순한 404 페이지 오류를 반환
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code  = 404
        }
    }
}

# ALB with ASG 서비스 연결
resource "aws_lb_listener_rule" "asg_api_server" {
    listener_arn = aws_lb_listener.http.arn
    priority     = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.asg_api_server.arn
    }
}

############################################

resource "aws_lb" "data_management" {
    name               = "${var.pre_tag_name}-alb-data-management"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

    tags = { Name = "${var.pre_tag_name}-alb-api-server" }
}

resource "aws_alb_target_group" "data_management" {
    name     = "${var.pre_tag_name}-albtg-data-management"
    port     = var.web_server_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id

    health_check {
        path                = "/health"
        port                = var.web_server_port
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }

    tags = { Name = "${var.pre_tag_name}-albtg-data-management" }
}

resource "aws_alb_target_group_attachment" "data_management" {
    target_group_arn = aws_alb_target_group.data_management.arn
    target_id        = aws_instance.data_management.id
    port             = var.web_server_port
}

resource "aws_lb_listener" "http_d" {
    load_balancer_arn = aws_lb.data_management.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code  = 404
        }
    }
}

resource "aws_lb_listener_rule" "data_management" {
    listener_arn = aws_lb_listener.http_d.arn
    priority     = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_alb_target_group.data_management.arn
    }
}
