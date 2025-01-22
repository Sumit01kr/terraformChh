variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "ig_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "eip_name" {
  description = "Name tag for the Elastic IP"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name tag for the NAT Gateway"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "az1" {
  description = "Availability Zone for the subnets"
  type        = string
}

variable "map_public_ip" {
  description = "Enable public IP assignment for the public subnet"
  type        = bool
  default     = true
}

variable "map_private_ip" {
  description = "dont Enable public IP assignment for the private subnet"
  type        = bool
  default     = false
}


variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
}

variable "public_route_table_name" {
  description = "Name tag for the public route table"
  type        = string
}

variable "private_route_table_name" {
  description = "Name tag for the private route table"
  type        = string
}

variable "private_route_cidr" {
  description = "CIDR block for the private route"
  type        = string
}
