variable "name" {
  description = "ECS cluster name"
}

variable "instance_type" {
  description = "EC2 instance type to run in ECS cluster"
}

variable "swap_size" {
  description = "Size of the swap file"
}

variable "number_of_instances" {
  description = "Number of instances in ECS cluster"
}

variable "min_number_of_instances" {
  description = "Minimum number of instances in ECS cluster"
}

variable "max_number_of_instances" {
  description = "Maximum number of instances in ECS cluster"
}

variable "key_pair" {
  description = "SSH key pair"
}

variable "cluster_instance_sg" {
  description = "Security group for ECS cluster instance"
}

variable "ecs_instance_iam_instance_profile" {
  description = "IAM instance profile with ECS instance role"
}

variable "subnet_ids" {
  description = "Subnet ids to launch ECS cluster instances in"
}
