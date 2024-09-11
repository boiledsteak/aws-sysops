# Create the security group
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Security group for EFS and SSH"
  vpc_id      = "vpc-0bb5af86ff040957f"

  # Allow all outbound traffic
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


# Allow NFS traffic within the same security group
resource "aws_security_group_rule" "efs_nfs_ingress" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}

# Allow SSH access from anywhere
resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.efs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}





