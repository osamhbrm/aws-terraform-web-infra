output "vpc" {
  value = aws_vpc.main.id
}

output "private1-db" {
  value = aws_subnet.private1-db.id
}
output "private2-db" {
  value = aws_subnet.private2-db.id
}
output "public1" {
  value = aws_subnet.public1.id
}
output "public2" {
  value = aws_subnet.public2.id
}
output "private1" {
  value = aws_subnet.private1.id
}
output "private2" {
  value = aws_subnet.private2.id
}