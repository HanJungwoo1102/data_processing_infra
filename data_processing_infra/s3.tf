resource "aws_s3_bucket" "temp_source" {
    bucket = "${var.pre_tag_name}-temp-source-bucket"

    tags = { Name = "${var.pre_tag_name}-s3-bucket-temp-source" }
}

resource "aws_s3_bucket" "l0" {
    bucket = "${var.pre_tag_name}-l0-bucket"

    tags = { Name = "${var.pre_tag_name}-s3-bucket-l0" }
}
