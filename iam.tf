resource "aws_iam_role_policy" "secrets_policy" {
  name = "allow-secrets-access"
  role = aws_iam_role.web_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}
# تعريف الـ Role
resource "aws_iam_role" "web_role" {
  name = "ec2-database-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "web-server-profile"
  role = aws_iam_role.web_role.name
}