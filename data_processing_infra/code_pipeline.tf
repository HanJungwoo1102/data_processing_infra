#============================================================
# Data Management
#============================================================

resource "aws_codepipeline" "data_management" {
    name = "${var.pre_tag_name}-code-pipeline-data-management"
    role_arn = aws_iam_role.code_pipeline.arn

    artifact_store {
        location = aws_s3_bucket.code_artifact.bucket
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            name             = "Source"
            category         = "Source"
            owner            = "AWS"
            provider         = "CodeStarSourceConnection"
            version          = "1"
            output_artifacts = ["source_artifact"]

            configuration = {
                ConnectionArn    = aws_codestarconnections_connection.github.arn
                FullRepositoryId = "${var.github_name}/${var.github_repository_data_management.name}"
                BranchName       = var.github_repository_data_management.branch
            }
        }
    }

    stage {
        name = "Build"

        action {
            name             = "Build"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_artifact"]
            output_artifacts = ["build_artifact"]
            version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.data_management.name
            }
        }
    }

    stage {
        name = "Deploy"

        action {
            name             = "Deploy"
            category         = "Deploy"
            owner            = "AWS"
            provider         = "CodeDeploy"
            input_artifacts  = ["build_artifact"]
            output_artifacts = []
            version          = "1"

            configuration = {
                ApplicationName = aws_codedeploy_app.data_management.name
                DeploymentGroupName = aws_codedeploy_deployment_group.data_management.deployment_group_name
            }
        }
    }

    tags = { Name = "${var.pre_tag_name}-code-pipeline-data-management" }
}

#============================================================
# Api Server
#============================================================

resource "aws_codepipeline" "api_server" {
    name = "${var.pre_tag_name}-code-pipeline-api-server"
    role_arn = aws_iam_role.code_pipeline.arn

    artifact_store {
        location = aws_s3_bucket.code_artifact.bucket
        type     = "S3"
    }

    stage {
        name = "Source"

        action {
            name             = "Source"
            category         = "Source"
            owner            = "AWS"
            provider         = "CodeStarSourceConnection"
            version          = "1"
            output_artifacts = ["source_artifact"]

            configuration = {
                ConnectionArn    = aws_codestarconnections_connection.github.arn
                FullRepositoryId = "${var.github_name}/${var.github_repository_api_server.name}"
                BranchName       = var.github_repository_api_server.branch
            }
        }
    }

    stage {
        name = "Build"

        action {
            name             = "Build"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_artifact"]
            output_artifacts = ["build_artifact"]
            version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.api_server.name
            }
        }
    }

    stage {
        name = "Deploy"

        action {
            name             = "Deploy"
            category         = "Deploy"
            owner            = "AWS"
            provider         = "CodeDeploy"
            input_artifacts  = ["build_artifact"]
            output_artifacts = []
            version          = "1"

            configuration = {
                ApplicationName = aws_codedeploy_app.api_server.name
                DeploymentGroupName = aws_codedeploy_deployment_group.api_server.deployment_group_name
            }
        }
    }

    tags = { Name = "${var.pre_tag_name}-code-pipeline-data-management" }
}

#============================================================
# Github Connection
#============================================================

resource "aws_codestarconnections_connection" "github" {
    name          = "${var.pre_tag_name}-codestar-conn-github"
    provider_type = "GitHub"
    tags = { Name = "${var.pre_tag_name}-codestar-conn-github" }
}
