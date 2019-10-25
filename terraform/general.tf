provider "aws" {
  region = "${var.region}"
  profile    = "private"
}

terraform {
  backend "s3" {
    bucket = "codingtips-java-kdb"
    key = "terraform/codingtips-java.tfstate"
    region = "eu-west-2"
    encrypt = "true"
    profile    = "private"
    dynamodb_table = "terraform-state"
  }
}