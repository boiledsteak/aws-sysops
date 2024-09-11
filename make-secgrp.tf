resource "aws_security_group" "webaccess" {
  name        = "webaccess"
  description = "Security group to allow SSH access and all outbound traffic"
  vpc_id      = "vpc-0bb5af86ff040957f"  # Reference your VPC

  # Inbound Rule: Allow SSH access (port 22)
  ingress {
	description = "Allow SSH access"
	from_port   = 22
	to_port     = 22
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere; restrict this based on your requirements
  }

  # Inbound Rule: Allow HTTP access (port 80)
  ingress {
	description = "Allow HTTP access"
	from_port   = 80
	to_port     = 80
	protocol    = "tcp"
	cidr_blocks = ["0.0.0.0/0"]  # Allows HTTP from anywhere; restrict if needed
  }

  # Outbound Rule: Allow all outbound traffic
  egress {
	description = "Allow all outbound traffic"
	from_port   = 0
	to_port     = 0
	protocol    = "-1"  # "-1" means all protocols
	cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
	Name = "webaccess"
  }
}
