provider "aws" {
  region = "us-east-1"

}
terraform {
  backend "s3" {
    bucket         = "osamhbrm"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}