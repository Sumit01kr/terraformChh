resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
   tags = {
    Name = "mymainvpc"
  }
}

resource "aws_internet_gateway" "myig" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "myig"
    }
  
}

resource "aws_eip" "myeip" {
    tags = {
        Name = "my_eip"
    }
}

resource "aws_nat_gateway" "nat1" {
    subnet_id     = aws_subnet.sub1.id
    allocation_id = aws_eip.myeip.id
    tags = {
        Name = "my_nat_gateway"
    }
  
}


#public subnet in AZ1
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public_subnet"
  }
}

#private subnet in AZ1
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
 

  tags = {
    Name = "Private_subnet"
  }
}

resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myig.id
  }
}


resource "aws_route_table_association" "a1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.rt1.id
}


resource "aws_route_table" "rt2" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "10.0.2.0/24"
        gateway_id = aws_nat_gateway.nat1.id
    }
  
}

resource "aws_route_table_association" "a2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.rt2.id
}






