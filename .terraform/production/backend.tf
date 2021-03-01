# Backend can't use variables, values have to be hardcoded

terraform {
  backend "remote" {
    organization = "boilerplate-api"

    workspaces {
      name = "production"
    }
  }
}
