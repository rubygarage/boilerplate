variable "region" {
  description = "AWS Region"
}

variable "project_name" {
  description = "Project name that will be visible in AWS resources"
}

variable "environment" {
  description = "Application environment"
}

variable "project_name_env" {
  description = "Project name with environment that will be visible in AWS resources names"
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention period in days"
}
