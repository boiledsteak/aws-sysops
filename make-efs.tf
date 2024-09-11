# Define the VPC and Subnets (assumed to be existing resources)
data "aws_vpc" "my_efs_vpc" {
  id = "vpc-0bb5af86ff040957f"  # Replace with your VPC ID
}




# Create EFS File System
resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs-file-system"
  performance_mode = "generalPurpose"  # General purpose or Max I/O based on your needs

  tags = {
    Name = "my-efs-file-system"
  }
}

# Create Mount Targets for EFS in the specified subnets
resource "aws_efs_mount_target" "mount_target_1" {
  file_system_id = aws_efs_file_system.my_efs.id
  subnet_id      = "subnet-0f6cbb1a1f7f490d7"

  security_groups = [
    aws_security_group.efs_sg.id
  ]
}
