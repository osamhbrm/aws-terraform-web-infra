output "secret" {
  value = aws_secretsmanager_secret.db_secret.arn

}