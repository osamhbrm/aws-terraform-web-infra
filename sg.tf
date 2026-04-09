# Security Group للـ Load Balancer (Public)
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

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
  vpc_id = aws_vpc.main.id

  
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
  vpc_id      = aws_vpc.main.id

  
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