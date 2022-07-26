resource "aws_lb" "api_server" {
    name               = "${var.pre_tag_name}-alb-api-server"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_api_server.id]
    subnets            = [aws_subnet.api_server_1.id, aws_subnet.api_server_2.id]

    tags = { Name = "${var.pre_tag_name}-alb-api-server" }
}

# ALB의 보안그룹 생성
resource "aws_security_group" "alb_api_server" {
    name = "${var.pre_tag_name}-security-group-alb-api-server"
    vpc_id = aws_vpc.vpc.id

    ## 인바운드 HTTP 트래픽 허용
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ## 모든 아웃바운드 트래픽을 허용
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "${var.pre_tag_name}-security-group-alb-api-server" }
}

# ALB 타겟그룹 생성
resource "aws_lb_target_group" "asg_api_server" {
    name     = "${var.pre_tag_name}-albtg-api-server"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id

    health_check {
        path                = "/"
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
