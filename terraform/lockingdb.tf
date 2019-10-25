/*
saves user,date,operation and path to state during operation as info and path as id, removed when operations ends
saves hash as digest afterward with path  hashtype as id ex path/state.tfstate-md5
*/


resource "aws_dynamodb_table" "terraform_state_table"{
    name = "terraform-state"
    hash_key = "LockID"
    read_capacity = 20
    write_capacity = 20
    attribute {
      name = "LockID"
      type = "S"
    }
}

resource "aws_iam_user_policy" "user_state_table_policy"{
  name = "state_table_policy"
  user = "Ken"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.terraform_state_table.arn}"
    }
  ]
}
EOF
}

//"Resource": "arn:aws:dynamodb:*:*:table/terraform-state"