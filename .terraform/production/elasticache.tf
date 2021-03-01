resource "aws_elasticache_cluster" "this" {
  cluster_id         = module.variables.project_name_env
  engine             = module.variables.elasticache_engine
  engine_version     = module.variables.elasticache_engine_version
  node_type          = module.variables.elasticache_node_type
  num_cache_nodes    = 1
  security_group_ids = [aws_security_group.redis_server.id]
}
