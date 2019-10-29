provider "aws" {
  region = "${var.region}"
  profile    = "${var.profile}"
}

/*
when terraform destroying-ing, the state DB needs to stay. Unfortunatley there is no exclude argument (yet) and prevent_destroy
fails whole plans/applies
=> workaround :
    - terraform state rm "module.lockingDB"
    - terraform state rm "module.stateS3"
    - terraform destroy
When reapply-ing infrastructure, state DB and policy already excist
=> import : ! this order, since policy references table!
    - terraform import module.lockingDB.aws_dynamodb_table.terraform_state_table terraform-state
    - terraform import module.lockingDB.aws_iam_user_policy.user_state_table_policy Ken:state_table_policy
    - terraform import module.stateS3.aws_s3_bucket.s3_bucket codingtips-java-kdb
    - terraform import module.stateS3.aws_iam_user_policy.user_s3_access_policy Ken:Terraform_S3

If delete does happen or we start frome a clean state -lock=false might be necessary
*/
module "lockingDB" {
  source = "./modules/lockingDB"
  user = "${var.user}"
}

module "stateS3"{
  source = "./modules/stateS3"
  user = "${var.user}"
}

terraform {
  backend "s3" {
    bucket = "codingtips-java-kdb"
    key = "terraform/codingtips-java.tfstate"
    region = "eu-west-2"
    encrypt = "true"
    dynamodb_table = "terraform-state"
    profile    = "private"
  }
}

/*
Getting final init ready
  2 ways:
    *
      - deploy S3 state bucket, DynamoDB state table and policies manually
      - init with s3 backend
    *
      - init without s3 backend
      - apply stateS3 and lockingDB modules
      - init with s3 backend
      - (possibly import module resources as above, probabilly when using -reconfigure, normaly second init will prompt for state migration)
*/