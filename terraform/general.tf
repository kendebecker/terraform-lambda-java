provider "aws" {
  region = "${var.region}"
  profile    = "${var.profile}"
}

/*
when terraform destroying-ing, the state DB needs to stay. Unfortunatley there is no exclude argument (yet) and prevent_destroy
fails the whole plan/apply
=> workaround :
    terraform state rm "module.lockingDB"
    terraform state rm "module.stateS3"
    terraform state rm "module.tipsDB"
    terraform destroy
When reapply-ing infrastructure, state and tips tables, bucket and policies already excist
=> import : ! this order, since policy references table!
            ! import tips table before apply since lambda policies reference tips table
    terraform import module.lockingDB.aws_dynamodb_table.terraform_state_table terraform-state
    terraform import module.lockingDB.aws_iam_user_policy.user_state_table_policy Ken:state_table_policy
    terraform import module.stateS3.aws_s3_bucket.s3_bucket codingtips-java-kdb
    terraform import module.stateS3.aws_iam_user_policy.user_s3_access_policy Ken:Terraform_S3
    terraform import module.tipsDB.aws_dynamodb_table.codingtips-dynamodb-table CodingTips-java-dynamodb
If delete does happen or we start frome a clean state -lock=false might be necessary
*/
module "lockingDB" {
  source = "./modules/lockingDB"
  user = "${var.user}"
  table_name = "${var.state_table_name}"
  policy_name = "${var.state_table_policy_name}"
}

module "stateS3"{
  source = "./modules/stateS3"
  user = "${var.user}"
  bucket_key = "${var.bucket_key}"
  bucket_name = "${var.bucket_name}"
  region = "${var.region}"
  policy_name = "${var.s3_policy_name}"
}

module "tipsDB"{
  source = "./modules/tipsDB"
  name = "${var.app_name}-${var.lang_prefix}-dynamodb"
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
      - import module resources, for bucket this will not 100% match tf config, fixed with apply
    *
      - init without s3 backend
      - apply lockingDB tipsDB and S3 modules, in this order for full state upload as part of S3
        S3 module might need -lock=false since we're uploading state while reading/writing it
      - init with s3 backend, state table might need update for /= digest
      - (possibly import module resources as above, probably when using -reconfigure, normaly second init will prompt for state migration)
*/