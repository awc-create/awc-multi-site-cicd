terraform {
  backend "s3" {
    bucket         = "awc-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
