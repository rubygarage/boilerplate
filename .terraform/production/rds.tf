locals {
  db_identifier = module.variables.project_name_env
}

resource "aws_db_instance" "this" {
  identifier                   = local.db_identifier
  name                         = replace(local.db_identifier, "-", "_")
  engine                       = module.variables.rds_engine
  engine_version               = module.variables.rds_engine_version
  instance_class               = module.variables.rds_instance_class
  allocated_storage            = module.variables.rds_allocated_storage
  storage_type                 = "gp2"
  username                     = replace(var.db_username, "-", "")
  password                     = var.db_password
  backup_retention_period      = module.variables.rds_backup_retention_period
  performance_insights_enabled = true
  deletion_protection          = true
  multi_az                     = false
  vpc_security_group_ids       = [aws_security_group.db_server.id]
}
