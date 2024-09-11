# Key Pair - Generate an RSA key pair for SSH access
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key-pair"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Create Security Group for SSH access
resource "aws_security_group" "internet-access" {
  name        = "internet-access"
  description = "Security group to allow SSH access"
  vpc_id      = aws_vpc.vpc1.id  # Replace with your existing VPC ID

  # Allow SSH access from anywhere (port 22)
  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "internet-access"
  }
}

# Amazon Linux 2 AMI for the Singapore region (ap-southeast-1)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Amazon Linux 2 AMI
  }
}

# Create EC2 Instance
resource "aws_instance" "myinstance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free tier eligible instance type

  # Use the key pair created above for SSH access
  key_name = aws_key_pair.my_key.key_name

  # Attach the security group for SSH access
  vpc_security_group_ids = [
    aws_security_group.internet-access.id,
    aws_security_group.efs_sg.id
    ]

  tags = {
    Name = "myinstance"
  }
}

# Output the private key
output "ssh_private_key" {
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
  description = "The private SSH key for accessing the EC2 instance."
}
 