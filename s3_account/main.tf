provider "aws" {
    region = "us-east-1"
}

variable "role_arn" {
    type = "string"
    description = "The ARN of the role on the redshift account that should be granted access to the bucket"
}

variable "bucket_name" {
    type = "string"
    description = "The name of the S3 bucket to which Redshift will UNLOAD"
}

resource "aws_s3_bucket" "redshift" {
    bucket = "${var.bucket_name}"
    acl = "private"
}

data "aws_iam_policy_document" "redshift" {
    statement {
        sid = "AllowS3"
        effect = "Allow"
        actions = [
            "s3:ListBucket",
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
        ]
        resources = [
            "${aws_s3_bucket.redshift.arn}",
            "${aws_s3_bucket.redshift.arn}/*",
        ]
        principals {
            type = "AWS"
            identifiers = ["${var.role_arn}"]
        }
    }
}

resource "aws_s3_bucket_policy" "redshift" {
    bucket = "${aws_s3_bucket.redshift.id}"
    policy = "${data.aws_iam_policy_document.redshift.json}"
}
