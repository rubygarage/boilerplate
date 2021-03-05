output "project_name" {
  value = var.project_name
}

output "environment" {
  value = var.environment
}

output "project_name_env" {
  value = "${var.project_name}-${var.environment}"
}

output "region" {
  value = lookup(var.region, var.environment)
}

output "server_name" {
  value = lookup(var.server_name, "${var.environment}-api")
}

output "first_level_server_name" {
  value = lookup(var.server_name, var.environment)
}

output "instance_type" {
  value = lookup(var.instance_type, var.environment)
}

output "rds_engine" {
  value = lookup(var.rds_engine, var.environment)
}

output "rds_engine_version" {
  value = lookup(var.rds_engine_version, var.environment)
}

output "rds_instance_class" {
  value = lookup(var.rds_instance_class, var.environment)
}

output "rds_allocated_storage" {
  value = lookup(var.rds_allocated_storage, var.environment)
}

output "rds_backup_retention_period" {
  value = lookup(var.rds_backup_retention_period, var.environment)
}

output "elasticache_engine" {
  value = lookup(var.elasticache_engine, var.environment)
}

output "elasticache_engine_version" {
  value = lookup(var.elasticache_engine_version, var.environment)
}

output "elasticache_node_type" {
  value = lookup(var.elasticache_node_type, var.environment)
}

output "swap_size" {
  value = lookup(var.swap_size, lookup(var.instance_type, var.environment))
}

output "task_cpu" {
  value = lookup(var.task_cpu, lookup(var.instance_type, var.environment))
}

output "task_memory" {
  value = lookup(var.task_memory, lookup(var.instance_type, var.environment))
}

output "min_task_count_application" {
  value = lookup(var.min_task_count_application, var.environment)
}

output "min_task_count_worker" {
  value = lookup(var.min_task_count_worker, var.environment)
}

output "min_task_count_cluster" {
  value = lookup(var.min_task_count_application, var.environment) + lookup(var.min_task_count_worker, var.environment)
}

output "max_task_count_application" {
  value = lookup(var.max_task_count_application, var.environment)
}

output "max_task_count_worker" {
  value = lookup(var.max_task_count_worker, var.environment)
}

output "max_task_count_cluster" {
  value = lookup(var.max_task_count_cluster, var.environment)
}

output "deployment_minimum_healthy_percent_application" {
  value = lookup(var.min_task_count_application, var.environment) <= 1 ? 0 : 100 / lookup(var.min_task_count_application, var.environment)
}

output "deployment_minimum_healthy_percent_worker" {
  value = lookup(var.min_task_count_worker, var.environment) <= 1 ? 0 : 100 / lookup(var.min_task_count_worker, var.environment)
}

output "deployment_maximum_percent" {
  value = lookup(var.deployment_maximum_percent, var.environment)
}

output "app_port" {
  value = lookup(var.app_port, var.environment)
}

output "log_retention_in_days" {
  value = lookup(var.log_retention_in_days, var.environment)
}
