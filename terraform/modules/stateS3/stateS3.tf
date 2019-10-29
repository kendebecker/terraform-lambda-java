variable "user"         {type = string}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "codingtips-java-kdb"
  acl    = "private"
  region = "eu-west-2"
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
  name = "Terraform_S3"
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

