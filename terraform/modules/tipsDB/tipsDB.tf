
locals {
  dynamodb_attributes = {
    Author    = "S"
    //Tip = "S" //Only needed for columns used as keys
    Date  = "N"
  }
}

variable "name"     {type= string}

resource "aws_dynamodb_table" "codingtips-dynamodb-table" {
  name = "${var.name}"
  read_capacity = 5
  write_capacity = 5
  hash_key = "Author"
  range_key = "Date"

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  dynamic "attribute"{
    for_each = local.dynamodb_attributes
    content{
      name = attribute.key
      type = attribute.value
    }
  }

  lifecycle {
    prevent_destroy = true
  }

//  attribute = [
//    {
//      name = "Author"
//      type = "S"
//    },
//    {
//      name = "Date"
//      type = "N"
//    }]
}

output "tipsDB_arn" {
  value = "${aws_dynamodb_table.codingtips-dynamodb-table.arn}"
}

output "tipsDB_stream_arn" {
  value = "${aws_dynamodb_table.codingtips-dynamodb-table.stream_arn}"
}

