output "vpc_id" {
  value = aws_vpc.placemux.id
}

output "public_subnet_1a" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_1b" {
  value = aws_subnet.public_1b.id
}

output "private_app_1a" {
  value = aws_subnet.private_app_1a.id
}

output "private_app_1b" {
  value = aws_subnet.private_app_1b.id
}

output "private_db_1a" {
  value = aws_subnet.private_db_1a.id
}

output "private_db_1b" {
  value = aws_subnet.private_db_1b.id
}