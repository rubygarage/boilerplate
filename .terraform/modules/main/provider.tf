provider "aws" {
  version = "~> 2.34"
  region  = var.region
}

provider "template" {
  version = "~> 2.1"
}
