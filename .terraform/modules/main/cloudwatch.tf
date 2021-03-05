resource "aws_cloudwatch_log_group" "this" {
  name              = var.project_name_env
  retention_in_days = var.log_retention_in_days
}
