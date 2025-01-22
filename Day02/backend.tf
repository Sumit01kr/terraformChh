terraform {
  backend "s3" {
    bucket = "sumitallbackend001"
    key    = "production/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "my_terraform_state"
  }
}
