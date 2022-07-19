resource "aws_s3_bucket" "temp_source" {
    bucket = "temp_source_bucket"

    tags = { Name = "${var.pre_tag_name}-s3-bucket-temp-source" }
}

resource "aws_s3_bucket" "l0" {
    bucket = "l0_bucket"

    tags = { Name = "${var.pre_tag_name}-s3-bucket-l0" }
}
