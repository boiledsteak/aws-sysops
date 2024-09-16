# Create S3 bucket for CloudTrail logs
# Create S3 bucket for CloudTrail logs with a unique name
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "my-cloudtrail-logs-bucket-${random_string.suffix.result}"

  tags = {
    Name = "CloudTrailLogsBucket"
  }
}

# Generate a random string for bucket name uniqueness
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Set S3 bucket ACL (to private) using aws_s3_bucket_acl resource
resource "aws_s3_bucket_acl" "cloudtrail_bucket_acl" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  acl    = "private"
}

# Enable CloudTrail
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "my-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true  # Include global services like IAM, STS, etc.
  is_multi_region_trail         = true  # Enable multi-region trail

  # Log management events (like IAM principal creation)
  event_selector {
    read_write_type           = "All"  # Logs both read and write operations
    include_management_events = true   # Logs all management events
  }

  tags = {
    Name = "CloudTrailTrail"
  }
}