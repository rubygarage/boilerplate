output "ecs_instance_iam_instance_profile" {
  value = aws_iam_instance_profile.ecs_instance
}

output "ecs_instance_iam_role" {
  value = aws_iam_role.ecs_instance
}

output "default_subnet_ids" {
  value = data.aws_subnet_ids.default.ids
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}
