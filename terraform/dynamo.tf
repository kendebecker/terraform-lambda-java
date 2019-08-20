resource "aws_dynamodb_table" "codingtips-dynamodb-table" {
  name = "${var.app_name}-${var.lang_prefix}-dynamodb"
  read_capacity = 5
  write_capacity = 5
  hash_key = "Author"
  range_key = "Date"

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

attribute = [
    {
      name = "Author"
      type = "S"
    },
    {
      name = "Date"
      type = "N"
    }]
}

