resource "aws_iam_user_policy" "user_s3_access_policy"{
  name = "Terraform_S3"
  user = "Ken"
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
            "Resource": "arn:aws:s3:::codingtips-java-kdb/terraform/codingtips-java.tfstate"
        }
    ]
}
EOF
}