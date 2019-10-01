provider "aws" {
  region = "${var.region}"
  profile    = "nickvh-jworks"
}

terraform {
  backend "s3" {
    bucket = "codingtips-java"
    key = "terraform/codingtips-java.tfstate"
    region = "eu-west-1"
    encrypt = "true"
  }
}