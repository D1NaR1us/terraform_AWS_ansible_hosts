# network vpc
resource "aws_default_vpc" "default" {
}

# Security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow traffic"
  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "RPC Endpoint Mapper from VPC"
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    description = "LDAP from VPC"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    description = "LDAP from VPC"
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    description = "SMB from VPC"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    description = "LDAP SSL from VPC"
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
