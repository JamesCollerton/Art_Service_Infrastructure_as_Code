# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials

variable "service_name" {}

provider "aws" {
  region     = "us-east-1"
  profile    = "ecsadministrator"
}

resource "aws_ecr_repository" "ecr-repository" {
  name = "${var.service_name}"
}

