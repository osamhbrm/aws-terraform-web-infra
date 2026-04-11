output "alb" {
  value = aws_security_group.alb_sg.id
}
output "web_profile" {
  value = aws_iam_instance_profile.web_profile.name
}
output "private_sg" {
  value = aws_security_group.web_private_sg.id

}
output "db_sg" {
  value = aws_security_group.db_sg.id

}