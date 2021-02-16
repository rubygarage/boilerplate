output "cluster" {
  value = aws_ecs_cluster.this
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.cluster-instance.name
}
