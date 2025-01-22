resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support    ## A boolean flag to enable/disable DNS support in the VPC. Defaults to true
  enable_dns_hostnames = var.enable_dns_hostnames     ## A boolean flag to enable/disable DNS hostnames in the VPC. Defaults to false
   tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "myig" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = var.ig_name
    }
  
}

resource "aws_eip" "myeip" {
    tags = {
        Name = var.eip_name
    }
}

resource "aws_nat_gateway" "nat1" {
    subnet_id     = aws_subnet.sub1.id
    allocation_id = aws_eip.myeip.id
    tags = {
        Name = var.nat_gateway_name
  
}
}


#public subnet in AZ1
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = var.map_public_ip   ## Specify true to indicate that instances launched into the subnet should be assigned a public IP address.

  tags = {
    Name = var.public_subnet_name
  }
}

#private subnet in AZ1
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = var.map_private_ip    ## Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
 

  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myig.id
        
  }
      tags = {
        Name = var.public_route_table_name

}
}


resource "aws_route_table_association" "a1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt1.id
}


resource "aws_route_table" "rt2" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = var.private_route_cidr
        gateway_id = aws_nat_gateway.nat1.id
    }

    tags = {
        Name = var.private_route_table_name
    }
  
}

resource "aws_route_table_association" "a2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt2.id
}

