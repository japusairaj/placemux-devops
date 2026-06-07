resource "aws_db_subnet_group" "placemux_db_subnet_group" {
  name = "placemux-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_db_1a.id,
    aws_subnet.private_db_1b.id
  ]

  tags = {
    Name = "placemux-db-subnet-group"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "placemux-postgres-sg"
  description = "Allow PostgreSQL access"
  vpc_id      = aws_vpc.placemux.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "placemux-postgres-sg"
  }
}

resource "aws_db_instance" "placemux_postgres" {
  identifier = "placemux-dev-postgres"

  engine         = "postgres"
  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "placemux"
  username = "placemuxadmin"
  password = "PlacemuxDev12345!"

  publicly_accessible = false

  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.placemux_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  tags = {
    Name        = "placemux-dev-postgres"
    Environment = "dev"
  }
}