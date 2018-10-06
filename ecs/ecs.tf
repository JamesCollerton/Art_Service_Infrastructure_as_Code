# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials

provider "aws" {
  region     = "us-east-1"
  profile    = "ecs_administrator"
}

resource "aws_ecr_repository" "artserviceecrrepository" {
  name = "artserviceecrrepository"
}
