# CodingTips

## Prerequisites
* install and configure AWS cli
* install Terraform

## Build And Deploy

### create s3 bucket
Terraform fetches the code from s3. 
Change the name of the S3 bucket `codingtips-node-bucket` to something of your liking.
Be sure to change it in the `upload-to-s3.sh` file and in the `general.tf` file under variable `variable "s3_bucket"          { default = "codingtips-node-bucket"}`

Create an s3 bucket via the cli with the next command.
```
aws s3api create-bucket --bucket codingtips-node-bucket --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
```

### Upload code to S3

- upload the code of the lambda functions to an S3 Bucket: 
```
./upload-to-s3.sh
```

### Deploy using terraform

```
cd terraform
terraform apply
```