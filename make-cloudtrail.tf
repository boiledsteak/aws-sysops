# Create S3 bucket for CloudTrail logs with a unique name
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "my-cloudtrail-logs-bucket-${random_string.suffix.result}"

  tags = {
    Name = "CloudTrailLogsBucket"
  }
}

# Generate a random string for bucket name uniqueness
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}


# Attach S3 bucket policy to allow CloudTrail to write logs
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:GetBucketAcl",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}"
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cloudtrail_bucket.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
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