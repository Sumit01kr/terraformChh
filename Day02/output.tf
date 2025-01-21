output "VPC_ID"{
    value = aws_vpc.myvpc.id
  }

output "public_subnet_id"{
     value = aws_subnet.sub1.id
  }

output "private_subnet_id"{
     value = aws_subnet.sub2.id
  }

output "cidr_block1" {
    value = aws_subnet.sub1.cidr_block
}

output "cidr_block2" {
    value = aws_subnet.sub2.cidr_block 
}