# Create a Launch Template for the ASG
resource "aws_launch_template" "my_launch_template" {
  name = "my-launch-template"

  # Specify the latest Amazon Linux 2 AMI
  image_id = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Free-tier eligible

  # Security group for the instance (sg-08c3a7cd7e0700daa)
  vpc_security_group_ids = ["sg-08c3a7cd7e0700daa"]

  # No SSH access - so no key pair
  disable_api_termination = false

  tags = {
    Name = "LaunchTemplate"
  }
}

# Create an Auto Scaling Group using the Launch Template
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = ["subnet-0f6cbb1a1f7f490d7"]  # Change to your actual subnet IDs

  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASGInstance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  # Health check based on EC2 instance state
  health_check_type = "EC2"
  health_check_grace_period = 300

  # Enabling scaling
  force_delete = true
}