############################################################
# VPC
############################################################
# This is the main network for the entire PlaceMux platform.
# All future services (EKS, RDS, Redis, GPU Nodes, etc.)
# will be deployed inside this VPC.
############################################################

resource "aws_vpc" "placemux" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "placemux-vpc"
    Project     = "PlaceMux"
    Environment = "shared"
  }
}

############################################################
# INTERNET GATEWAY
############################################################
# Allows resources in public subnets to access the internet.
# Required for:
# - Load Balancers
# - NAT Gateway (future)
# - Public facing services
############################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.placemux.id

  tags = {
    Name = "placemux-igw"
  }
}

############################################################
# PUBLIC SUBNETS
############################################################
# Public Subnets will host:
# - Application Load Balancer
# - NAT Gateway
#
# Multi-AZ design for High Availability.
############################################################

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.placemux.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1a"
    Tier = "public"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.placemux.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1b"
    Tier = "public"
  }
}

############################################################
# PRIVATE APPLICATION SUBNETS
############################################################
# Application Layer
#
# Future Services:
# - EKS Worker Nodes
# - Backend APIs
# - AI Services
# - Monitoring Stack
# - GPU Inference Pods
############################################################

resource "aws_subnet" "private_app_1a" {
  vpc_id            = aws_vpc.placemux.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-app-1a"
    Tier = "application"
  }
}

resource "aws_subnet" "private_app_1b" {
  vpc_id            = aws_vpc.placemux.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-app-1b"
    Tier = "application"
  }
}

############################################################
# PRIVATE DATABASE SUBNETS
############################################################
# Database Layer
#
# Future Services:
# - PostgreSQL RDS
# - Redis
# - Internal Databases
#
# No direct internet access.
############################################################

resource "aws_subnet" "private_db_1a" {
  vpc_id            = aws_vpc.placemux.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-db-1a"
    Tier = "database"
  }
}

resource "aws_subnet" "private_db_1b" {
  vpc_id            = aws_vpc.placemux.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-db-1b"
    Tier = "database"
  }
}

############################################################
# PUBLIC ROUTE TABLE
############################################################
# Allows internet traffic through Internet Gateway.
#
# Route:
# 0.0.0.0/0 -> Internet Gateway
############################################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.placemux.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "placemux-public-rt"
  }
}

############################################################
# ROUTE TABLE ASSOCIATIONS
############################################################
# Connect public subnets to public route table.
############################################################

resource "aws_route_table_association" "public_assoc_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rt.id
}