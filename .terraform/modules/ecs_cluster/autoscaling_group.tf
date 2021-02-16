resource "aws_autoscaling_group" "cluster-instance" {
  name                      = var.name
  vpc_zone_identifier       = var.subnet_ids
  desired_capacity          = var.number_of_instances
  min_size                  = var.min_number_of_instances
  max_size                  = var.max_number_of_instances
  health_check_grace_period = 30

  launch_template {
    id = aws_launch_template.this.id
  }
}
