provider "aws" {
  region = "${var.region}"
  profile    = "${var.profile}"
}

/*
when terraform delete-ing, the state DB needs to stay. Unfortunatley there is no exclude argument (yet) and prevent_destroy
fails whole plans/applies
=> workaround :
    - terraform state rm "module.lockingDB"
    - terraform destroy
When reapply-ing infrastructure, state DB and policy already excist
=> import : ! this order, since policy references table!
    - terraform import module.lockingDB.aws_dynamodb_table.terraform_state_table terraform-state
    - terraform import module.lockingDB.aws_iam_user_policy.user_state_table_policy Ken:state_table_policy

If delete does happen or we start frome a clean state -lock=false might be necessary
*/
module "lockingDB" {
  source = "./modules/lockingDB"
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