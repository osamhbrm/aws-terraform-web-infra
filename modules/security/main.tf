resource "aws_iam_role_policy" "secrets_policy" {
  name = "allow-secrets-access"
  role = aws_iam_role.web_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = var.SecretM
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
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
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
# Security Group للـ Load Balancer (Public)
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Web Servers 
resource "aws_security_group" "web_private_sg" {
  name   = "web-private-sg"
  vpc_id = var.vpc


  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#security Group for db
resource "aws_security_group" "db_sg" {
  name        = "database-sg"
  description = "Allow traffic only from Web SG"
  vpc_id      = var.vpc


  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "db-sg" }
}