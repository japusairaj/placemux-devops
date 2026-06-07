#############################################
# S3 Bucket for Proctoring Artifacts
# Day 3 - Core Data Infrastructure
#############################################

resource "aws_s3_bucket" "placemux_artifacts" {
  bucket = "placemux-artifacts-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "placemux-artifacts"
    Environment = "dev"
    Project     = "PlaceMux"
  }
}

#############################################
# Random Suffix (Bucket names must be unique)
#############################################

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

#############################################
# Enable Versioning
#############################################

resource "aws_s3_bucket_versioning" "placemux_artifacts_versioning" {
  bucket = aws_s3_bucket.placemux_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

#############################################
# Enable Server Side Encryption
#############################################

resource "aws_s3_bucket_server_side_encryption_configuration" "placemux_artifacts_encryption" {
  bucket = aws_s3_bucket.placemux_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#############################################
# Block Public Access
#############################################

resource "aws_s3_bucket_public_access_block" "placemux_artifacts_block" {
  bucket = aws_s3_bucket.placemux_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#############################################
# Analytics Bucket
#############################################

resource "aws_s3_bucket" "placemux_analytics" {
  bucket = "placemux-analytics-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "placemux-analytics"
    Environment = "dev"
    Project     = "PlaceMux"
  }
}

resource "aws_s3_bucket_versioning" "placemux_analytics_versioning" {
  bucket = aws_s3_bucket.placemux_analytics.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "placemux_analytics_encryption" {
  bucket = aws_s3_bucket.placemux_analytics.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "placemux_analytics_block" {
  bucket = aws_s3_bucket.placemux_analytics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}