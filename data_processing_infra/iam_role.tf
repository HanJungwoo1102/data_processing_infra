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

resource "aws_iam_role_policy_attachment" "code_deploy_ec2" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
    role       = aws_iam_role.code_deploy_ec2.name
}

resource "aws_iam_role_policy_attachment" "code_deploy_ec2_cloud_watch" {
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
    role       = aws_iam_role.code_deploy_ec2.name
}

resource "aws_iam_instance_profile" "code_deploy_ec2" {
    name = "${var.pre_tag_name}-iam-instance-profile-codedeploy-ec2"
    role = aws_iam_role.code_deploy_ec2.name
}

#============================================================
# Code Build Role
#============================================================

resource "aws_iam_role" "code_build" {
    name = "${var.pre_tag_name}-iam-role-code-build"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "codebuild.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            },
        ]
    })
}

resource "aws_iam_role_policy" "code_build" {
    role = aws_iam_role.code_build.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Resource = [
                    "*"
                ],
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
            },
            {
                Effect = "Allow",
                Action = [
                    "ec2:CreateNetworkInterface",
                    "ec2:DescribeDhcpOptions",
                    "ec2:DescribeNetworkInterfaces",
                    "ec2:DeleteNetworkInterface",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeVpcs"
                ],
                Resource = "*"
            },
            # {
            #     Effect = "Allow",
            #     Action = [
            #         "ec2:CreateNetworkInterfacePermission"
            #     ],
            #     Resource [
            #         "arn:aws:ec2:us-east-1:123456789012:network-interface/*"
            #     ],
            #     Condition = {
            #         StringEquals = {
            #         ec2:Subnet = [
            #             "${aws_subnet.example1.arn}",
            #             "${aws_subnet.example2.arn}"
            #         ],
            #         ec2:AuthorizedService = "codebuild.amazonaws.com"
            #         }
            #     }
            # },
            {
                Effect = "Allow",
                Action = [
                    "s3:*"
                ],
                Resource = [
                    "${aws_s3_bucket.code_artifact.arn}",
                    "${aws_s3_bucket.code_artifact.arn}/*"
                ]
            }
        ]
    })
}

#============================================================
# Code Deploy Role
#============================================================

resource "aws_iam_role" "code_deploy" {
    name = "${var.pre_tag_name}-iam-role-code-deploy"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Sid = "",
                Effect = "Allow",
                Principal = {
                    Service: "codedeploy.amazonaws.com"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy" "code_deploy" {
    role = aws_iam_role.code_deploy.name

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Resource = [
                    "*"
                ],
                Action = [
                    "EC2:RunInstances",
                    "EC2:CreateTags",
                    "iam:PassRole",
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "code_deploy" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    role       = aws_iam_role.code_deploy.name
}

#============================================================
# Code Pipeline Role
#============================================================

resource "aws_iam_role" "code_pipeline" {
    name = "${var.pre_tag_name}-iam-role-code-pipeline"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Sid    = ""
                Principal = {
                    Service = "codepipeline.amazonaws.com"
                }
                Action = "sts:AssumeRole"
            },
        ]
    })

    tags = { Name = "${var.pre_tag_name}-iam-role-code-pipeline" }
}

resource "aws_iam_role_policy" "code_pipeline" {
    name = "${var.pre_tag_name}-iam-role-policy-code-pipeline"
    role = aws_iam_role.code_pipeline.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "s3:GetObject",
                    "s3:GetObjectVersion",
                    "s3:GetBucketVersioning",
                    "s3:PutObjectAcl",
                    "s3:PutObject"
                ],
                Resource = [
                    "${aws_s3_bucket.code_artifact.arn}",
                    "${aws_s3_bucket.code_artifact.arn}/*"
                ]
            },
            {
                Effect = "Allow",
                Action = [
                    "codestar-connections:UseConnection"
                ],
                Resource = "${aws_codestarconnections_connection.github.arn}"
            },
            {
                Effect = "Allow",
                Action = [
                    "codebuild:BatchGetBuilds",
                    "codebuild:StartBuild"
                ],
                Resource = "*"
            },
            {
                Effect = "Allow",
                Action = [
                    "codedeploy:*",
                ],
                Resource = [
                    aws_codedeploy_deployment_group.data_management.arn,
                    aws_codedeploy_deployment_group.api_server.arn,
                    aws_codedeploy_app.api_server.arn,
                    aws_codedeploy_app.data_management.arn,
                ]
            },
            {
                Effect = "Allow",
                Action = [
                    "codedeploy:GetDeploymentConfig"
                ],
                Resource : "*"
            },
        ]
    })
}
