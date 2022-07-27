resource "aws_iam_role" "code_deploy_ec2" {
    name = "${var.pre_tag_name}-iam-role-code-deploy-ec2"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            },
        ]
    })

    tags = { Name = "${var.pre_tag_name}-iam-role-code-deploy-ec2" }
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    role       = aws_iam_role.code_deploy_ec2.name
}

resource "aws_iam_instance_profile" "code_deploy_ec2" {
    name = "${var.pre_tag_name}-iam-profile-code-deploy-ec2"
    role = aws_iam_role.code_deploy_ec2.name
}
