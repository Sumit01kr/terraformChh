provider "aws" {
    region = "ap-south-1"
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

}

resource "aws_instance" "my_instance" {
  ami = "ami-00bb6a80f01f03502"  # Use the correct AMI ID
  instance_type = "t2.micro"
  subnet_id = "subnet-0d13c39effaee3300"  # Use an existing subnet ID or create one
  
}

resource "aws_db_instance" "my_rds" {
  identifier = "my-db-instance"
  engine     = "mysql"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  username   = "admin"
  password   = "password123"
  db_name    = "mydatabase"
}