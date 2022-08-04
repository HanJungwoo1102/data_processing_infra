resource "aws_codebuild_project" "data_management" {
    name = "${var.pre_tag_name}-code-build-data-management"
    service_role  = aws_iam_role.code_build.arn

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        environment_variable {
            name  = "ENV_CONTENTS"
            value = var.env_contents_data_management
        }
    }

    source {
        type            = "S3"
        location        = "${aws_s3_bucket.code_artifact.bucket}/source_artifact"
    }

    artifacts {
        type = "S3"
        packaging = "ZIP"
        location = aws_s3_bucket.code_artifact.bucket
        name = "build_artifact"
    }

    tags = { Name = "${var.pre_tag_name}-code-build-data-management" }
}

resource "aws_codebuild_project" "api_server" {
    name = "${var.pre_tag_name}-code-build-api-server"
    service_role  = aws_iam_role.code_build.arn

    environment {
        compute_type                = "BUILD_GENERAL1_SMALL"
        image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
        type                        = "LINUX_CONTAINER"
        image_pull_credentials_type = "CODEBUILD"

        environment_variable {
            name  = "ENV_CONTENTS"
            value = var.env_contents_api_server
        }
    }

    source {
        type            = "S3"
        location        = "${aws_s3_bucket.code_artifact.bucket}/source_artifact"
    }

    artifacts {
        type = "S3"
        packaging = "ZIP"
        location = aws_s3_bucket.code_artifact.bucket
        name = "build_artifact"
    }

    tags = { Name = "${var.pre_tag_name}-code-build-api-server" }
}
