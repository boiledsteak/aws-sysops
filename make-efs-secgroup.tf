# Get the existing instance
data "aws_instance" "my_instance" {
  instance_id = "i-06cd9cf1868e19c51"  # Replace with your instance ID
}

# Modify security groups for the existing instance
resource "aws_instance_security_group_association" "associate_sg" {
  instance_id       = data.aws_instance.my_instance.id
  security_group_id = aws_security_group.efs_sg.id
}


# Create a security group for EFS
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Allow NFS traffic for EFS within the same security group and SSH access"
  vpc_id      = "vpc-0bb5af86ff040957f"  # Replace with your VPC ID reference if needed

  # Inbound rule: Allow NFS traffic (port 2049) for members of the same security group
  ingress {
    description = "Allow NFS traffic within the same security group"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.efs_sg.id]  # Reference to the same security group
  }

  # Inbound rule: Allow SSH traffic (port 22) from anywhere
  ingress {
    description = "Allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # This allows access from any IP
  }

  # Outbound rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}
