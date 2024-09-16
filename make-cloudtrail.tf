# Create S3 bucket for CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "my-cloudtrail-logs-bucket"
  acl    = "private"

  tags = {
    Name = "CloudTrailLogsBucket"
  }
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

# Output the S3 bucket name for verification
output "s3_bucket_name" {
  value = aws_s3_bucket.cloudtrail_bucket.id
}

# Output the CloudTrail name
output "cloudtrail_name" {
  value = aws_cloudtrail.cloudtrail.name
}
