
#This provider generates random values, like strings or numbers, to add uniqueness to resources.
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "random" {
  # Configuration options
}

#Specifies that the AWS resources will be created in the ap-south-1 region
provider "aws" {
  region  = "ap-south-1"
  version = "~> 5.0"
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-basics-bucket-${random_string.random.result}"
  acl    = "private"
}

#This creates a random string to ensure the S3 bucket name is unique globally.Prevents naming conflicts.
resource "random_string" "random" {
  length           = 16             # The length of the random string
  special          = false          # No special characters are included.
  upper            = false          # Only lowercase characters are used.
}

 