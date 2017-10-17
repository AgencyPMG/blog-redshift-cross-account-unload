provider "aws" {
    region = "us-east-1"
}

variable "role_name" {
    type = "string"
    description = "The name of the role redshift will assume"
}

variable "bucket_name" {
    type = "string"
    description = "The name of the target S3 bucket"
}

data "aws_iam_policy_document" "assume" {
    statement {
        sid = "AllowRedshiftAssume"
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["redshift.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "redshift" {
    name = "${var.role_name}"
    assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "perms" {
    statement {
        sid = "AllowS3"
        effect = "Allow"
        actions = ["s3:*"]
        resources = [
            "arn:aws:s3:::${var.bucket_name}",
            "arn:aws:s3:::${var.bucket_name}/*",
        ]
    }
}

resource "aws_iam_role_policy" "redshift_s3" {
    name = "redshift-s3"
    role = "${aws_iam_role.redshift.id}"
    policy = "${data.aws_iam_policy_document.perms.json}"
}

output "role_arn" {
    value = "${aws_iam_role.redshift.arn}"
}
