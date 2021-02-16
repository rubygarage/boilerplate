data "aws_ami" "ecs_optimized" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20191114-x86_64-ebs"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cluster_name = aws_ecs_cluster.this.name
    swap_size    = var.swap_size
  }
}

resource "aws_launch_template" "this" {
  name                   = var.name
  instance_type          = var.instance_type
  key_name               = var.key_pair.key_name
  vpc_security_group_ids = [var.cluster_instance_sg.id]
  image_id               = data.aws_ami.ecs_optimized.id
  user_data              = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.ecs_instance_iam_instance_profile.name
  }
}
