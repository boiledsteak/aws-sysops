# Update IAM Role Trust Policy
resource "aws_iam_role" "cloudwatcher" {
  name = "cloudwatcher"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "cloudformation.amazonaws.com",
        },
      },
    ],
  })
}

# Attach AWSQuickSetupDeploymentRolePolicy to the Role
resource "aws_iam_role_policy_attachment" "quicksetup_deployment_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSQuickSetupDeploymentRolePolicy"
  role     = aws_iam_role.cloudwatcher.name
}


# Attach AWSCloudFormationFullAccess to the Role
resource "aws_iam_role_policy_attachment" "cloudformation_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
  role     = aws_iam_role.cloudwatcher.name
}

# Attach CloudWatchAgentAdminPolicy to the Role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
  role     = aws_iam_role.cloudwatcher.name
}

# Attach AmazonEC2FullAccess to the Role
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role     = aws_iam_role.cloudwatcher.name
}

# Attach AmazonSSMFullAccess to the Role
resource "aws_iam_role_policy_attachment" "ssm_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  role     = aws_iam_role.cloudwatcher.name
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "cloudwatcher_profile" {
  name = "cloudwatcher-instance-profile"
  role = aws_iam_role.cloudwatcher.name
}

# Attach AmazonS3FullAccess to the Role
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.cloudwatcher.name
}