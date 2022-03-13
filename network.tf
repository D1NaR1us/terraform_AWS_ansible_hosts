# network vpc
resource "aws_vpc" "ansible_host" {    
    cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "ansible_host"
    }
}

# Internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.ansible_host.id
  tags = {
    Name = "my_igw"
  }
}

# Route table
resource "aws_route_table" "my_route_table" {
    vpc_id = aws_vpc.ansible_host.id
    route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
    }  
}

# Main route table
resource "aws_main_route_table_association" "my_main_route_table" {
  vpc_id         = aws_vpc.ansible_host.id
  route_table_id = aws_route_table.my_route_table.id
}

# Subnet
resource "aws_subnet" "test_main_subnet" {
    vpc_id = aws_vpc.ansible_host.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true
    depends_on = [aws_internet_gateway.my_igw]
    tags = {
        Name = "ansible_subnet"
    }
    
}

# Security group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow traffic"
  vpc_id = aws_vpc.ansible_host.id

  ingress {
    description = "RPC Endpoint Mapper from VPC"
    from_port   = 135
    to_port     = 135
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ansible_host.cidr_block]
  }
  ingress {
    description = "LDAP from VPC"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ansible_host.cidr_block]
  }
  ingress {
    description = "LDAP from VPC"
    from_port   = 389
    to_port     = 389
    protocol    = "udp"
    cidr_blocks = [aws_vpc.ansible_host.cidr_block]
  }
  ingress {
    description = "SMB from VPC"
    from_port   = 445
    to_port     = 445
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ansible_host.cidr_block]
  }
  ingress {
    description = "LDAP SSL from VPC"
    from_port   = 636
    to_port     = 636
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.ansible_host.cidr_block]
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
