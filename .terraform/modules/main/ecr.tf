resource "aws_ecr_repository" "web_server" {
  name = "${var.project_name}/${var.environment}/web-server"
}

resource "aws_ecr_repository" "app" {
  name = "${var.project_name}/${var.environment}/server-app"
}
