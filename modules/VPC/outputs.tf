output "vpc_id" {
    value = aws_vpc.my-vpc.id
  
}
output "aws_subnet_id" {
    value = aws_subnet.subnet-1.id
}