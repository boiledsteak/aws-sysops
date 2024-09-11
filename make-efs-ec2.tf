# Key Pair - Generate an RSA key pair for SSH access
resource "tls_private_key" "efs-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my-efs-key-pair" {
  key_name   = "my-efs-key-pair"
  public_key = tls_private_key.efs-ssh-key.public_key_openssh
}

# Amazon Linux 2 AMI for the Singapore region (ap-southeast-1)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp3"]  # Amazon Linux 2 AMI
  }
}

# Create EC2 Instance
resource "aws_instance" "efs-instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free tier eligible instance type

  # Use the key pair created above for SSH access
  key_name = aws_key_pair.my-efs-key-pair.key_name

  # Attach the security group for SSH access and NFS
  vpc_security_group_ids = [
    aws_security_group.internet-access.id,
    aws_security_group.efs_sg.id
    ]

  tags = {
    Name = "instance"
  }
}

# Output the private key
output "ssh_private_key" {
  value       = tls_private_key.efs-ssh-key.private_key_pem
  sensitive   = true
  description = "The private SSH key for accessing the NFS server EC2 instance"
}