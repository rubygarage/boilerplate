variable "project_name" {
  description = "Project name that will be visible in AWS resources names"
  default     = "boilerplate-api"
}

variable "environment" {
  description = "Application environment"
}

variable "region" {
  description = "AWS Region"

  type = map(string)
  default = {
    staging    = "us-west-1"
    production = "us-we st-1"
  }
}

variable "server_name" {
  description = "Domain name for application"

  type = map(string)
  default = {
    staging-api    = "staging-api.boilerplate.com"
    production-api = "api.boilerplate.com"
    staging        = "staging.boilerplate.com"
    production     = "boilerplate.com"
  }
}

variable "instance_type" {
  description = "AWS EC2 instance type"

  type = map(string)
  # TODO: Use at least t3.micro/t3a.micro for real staging
  default = {
    staging    = "t3a.nano"
    production = "t3a.small"
  }
}

variable "rds_engine" {
  description = "AWS RDS engine"

  type = map(string)
  default = {
    staging    = "postgres"
    production = "postgres"
  }
}

variable "rds_engine_version" {
  description = "AWS RDS engine version"

  type = map(string)
  default = {
    staging    = "10.12"
    production = "11.5"
  }
}

variable "rds_instance_class" {
  description = "AWS RDS instance type"

  type = map(string)
  default = {
    staging    = "db.t2.micro"
    production = "db.t3.micro"
  }
}

variable "rds_allocated_storage" {
  description = "AWS RDS allocated storage"

  type = map(number)
  default = {
    staging    = 20
    production = 20
  }
}

variable "rds_backup_retention_period" {
  description = "AWS RDS backup retention period"

  type = map(number)
  default = {
    staging    = 0
    production = 30
  }
}

variable "elasticache_engine" {
  description = "ElastiCache engine"

  type = map(string)
  default = {
    staging    = "redis"
    production = "redis"
  }
}

variable "elasticache_engine_version" {
  description = "ElastiCache engine version"

  type = map(string)
  default = {
    staging    = "5.0.6"
    production = "5.0.6"
  }
}

variable "elasticache_node_type" {
  description = "ElastiCache node type"

  type = map(string)
  default = {
    staging    = "cache.t2.micro"
    production = "cache.t3.micro"
  }
}

variable "swap_size" {
  description = "AWS EC2 instance Swap size in MB"

  type = map(number)
  default = {
    "t3.nano"    = 2048
    "t3a.nano"   = 2048
    "t3.micro"   = 2048
    "t3a.micro"  = 2048
    "t3.small"   = 2048
    "t3a.small"  = 2048
    "t3.medium"  = 4096
    "t3a.medium" = 4096
  }
}

variable "task_cpu" {
  description = "The number of CPU units used by the task"

  type = map(number)
  default = {
    "t3.nano"    = 1792
    "t3a.nano"   = 1792
    "t3.micro"   = 1792
    "t3a.micro"  = 1792
    "t3.small"   = 1792
    "t3a.small"  = 1792
    "t3.medium"  = 1792
    "t3a.medium" = 1792
  }
}

variable "task_memory" {
  description = "The amount (in MiB) of memory used by the task"

  type = map(number)
  default = {
    "t3.nano"    = 397
    "t3a.nano"   = 397
    "t3.micro"   = 893
    "t3a.micro"  = 893
    "t3.small"   = 1792
    "t3a.small"  = 1792
    "t3.medium"  = 3584
    "t3a.medium" = 3584
  }
}

variable "min_task_count_application" {
  description = "AWS ECS Application Minimum task count"

  type = map(number)
  default = {
    staging    = 1
    production = 1
  }
}

variable "min_task_count_worker" {
  description = "AWS ECS Worker Minimum task count"

  type = map(number)
  default = {
    staging    = 1
    production = 1
  }
}

variable "max_task_count_application" {
  description = "AWS ECS Application Maximum task count"

  type = map(number)
  default = {
    staging    = 1
    production = 2
  }
}

variable "max_task_count_worker" {
  description = "AWS ECS Worker Maximum task count"

  type = map(number)
  default = {
    staging    = 1
    production = 2
  }
}

variable "max_task_count_cluster" {
  description = "AWS ECS Cluster Maximum task count"

  type = map(number)
  default = {
    staging    = 2
    production = 4
  }
}

variable "deployment_minimum_healthy_percent" {
  description = "Service deployment minimum percent"

  type = map(number)
  default = {
    staging    = 0
    production = 0
  }
}

variable "deployment_maximum_percent" {
  description = "Service deployment Maximum percent"

  type = map(number)
  default = {
    staging    = 100
    production = 100
  }
}

variable "app_port" {
  description = "Port that application listens on to receive requests"

  type = map(number)
  default = {
    staging    = 3000
    production = 3000
  }
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention period in days"

  type = map(number)

  default = {
    staging    = 30
    production = 90
  }
}

# Both SSL basenames below are needed only for managing SSL by NGINX, not by Load Balancer

variable "ssl_certificate_basename" {
  description = "Bundled SSL certificate file name"

  type = map(string)
  default = {
    staging    = "rails-app.ml.bundled.crt"
    production = ""
  }
}

variable "ssl_certificate_key_basename" {
  description = "SSL certificate private key file name"

  type = map(string)
  default = {
    staging    = "rails-app.ml.key"
    production = ""
  }
}
