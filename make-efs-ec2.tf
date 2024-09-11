# Key Pair - Generate an RSA key pair for SSH access
resource "tls_private_key" "efs-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my-efs-key-pair" {
  key_name   = "my-efs-key-pair"
  public_key = tls_private_key.efs-ssh-key.public_key_openssh
}


# Define the VPC (assuming you have an existing VPC)
data "aws_vpc" "my_vpc" {
  id = "vpc-0bb5af86ff040957f"  # Replace with your VPC ID
}

# Define the subnet within the VPC
data "aws_subnet" "efs_my_subnet" {
  id = "subnet-0f6cbb1a1f7f490d7"  # Replace with your Subnet ID
}


# Create EC2 Instance
resource "aws_instance" "efs-instance" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free tier eligible instance type

  # Use the key pair created above for SSH access
  key_name = aws_key_pair.my-efs-key-pair.key_name

  # Specify the subnet to launch the instance in
  subnet_id = data.aws_subnet.efs_my_subnet.id

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
output "efs_ssh_private_key" {
  value       = tls_private_key.efs-ssh-key.private_key_pem
  sensitive   = true
  description = "The private SSH key for accessing the NFS server EC2 instance"
}