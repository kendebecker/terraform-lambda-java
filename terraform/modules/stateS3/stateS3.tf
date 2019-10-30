variable "user"         {type = string}
variable "bucket_name"         {type = string}
variable "bucket_key"         {type = string}
variable "region"         {type = string}
variable "policy_name"         {type = string}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  region = "${var.region}"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_iam_user_policy" "user_s3_access_policy"{
  name = "${var.policy_name}"
  user = "${var.user}"
  lifecycle {
    prevent_destroy = true
  }
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::codingtips-java-kdb"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "${aws_s3_bucket.s3_bucket.arn}/terraform/codingtips-java.tfstate"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  key    = "${var.bucket_key}"
  source = "terraform.tfstate"
  content_type = "application/json"
  depends_on = [
    "aws_s3_bucket.s3_bucket",
    "aws_iam_user_policy.user_s3_access_policy"
  ]
}

