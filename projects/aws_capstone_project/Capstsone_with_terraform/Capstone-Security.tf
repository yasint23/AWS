#///////////WEB SERVER SECURİTY GROUPS/////////

resource "aws_security_group" "WebServer-sg" {
  name        = "WebServer-sg"
  description = "Allow HTTP and SSH port from ELB"
  vpc_id      = aws_vpc.Capstone-VPC.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ELB-sg.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ELB-sg.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-WebServer-sg"
  }
}

#/////////////ELASTIC LOAD BALANCER SECURITY GROUPS///////////

resource "aws_security_group" "ELB-sg" {
  name        = "ELB-sg"
  description = "Allow HTTP/HTTPS and SSH port"
  vpc_id      = aws_vpc.Capstone-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-ELB-sg"
  }
}

#/////////////////RDS SECURITY GROUPS//////////////////

resource "aws_security_group" "RDS-sg" {
  name        = "RDS-sg"
  description = "Allow from webserver"
  vpc_id      = aws_vpc.Capstone-VPC.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.WebServer-sg.id}"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-RDS-sg"
  }
}

#///////////////NAT INSTANCE SECURITY GROUPS/////////////

resource "aws_security_group" "NAT-sg" {
  name        = "NAT-sg"
  description = "Allow HTTP/HTTPS and SSH port"
  vpc_id      = aws_vpc.Capstone-VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-NAT-sg"
  }
}

#///////////////LAMBDA FUNCTION SECURITY GROUPS/////////////

resource "aws_security_group" "Lambda_sg" {
  name        = "Lambda-sg"
  description = "Allow HTTP/HTTPS and SSH port"
  vpc_id      = aws_vpc.Capstone-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-Lambda-sg"
  }
}