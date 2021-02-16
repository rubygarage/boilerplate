# Task definition

data "template_file" "worker_definitions" {
  template = file("${path.module}/templates/worker_definitions.json")

  vars = {
    project_name = module.variables.project_name
    environment  = module.variables.environment

    app_ecr_repo = module.main.ecr_repositories.app.repository_url

    log_group  = module.main.aws_cloudwatch_log_group.name
    log_region = module.variables.region
  }
}

resource "aws_ecs_task_definition" "worker_task_definition" {
  family       = "${module.variables.project_name_env}-worker"
  network_mode = "bridge"
  cpu          = module.variables.task_cpu
  memory       = module.variables.task_memory

  volume {
    name = "public"
  }

  container_definitions = data.template_file.worker_definitions.rendered
}

# Service

resource "aws_ecs_service" "worker-service" {
  name                               = "${module.variables.project_name_env}-worker"
  cluster                            = module.ecs_cluster.cluster.id
  task_definition                    = aws_ecs_task_definition.worker_task_definition.arn
  desired_count                      = module.variables.min_task_count_worker
  deployment_minimum_healthy_percent = module.variables.deployment_minimum_healthy_percent_worker
  deployment_maximum_percent         = module.variables.deployment_maximum_percent

  depends_on = [
    module.global.ecs_instance_iam_role
  ]

  lifecycle {
    ignore_changes = [desired_count]
  }
}
