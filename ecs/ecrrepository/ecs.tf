# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials

provider "aws" {
  region     = "us-east-1"
  profile    = "ecsadministrator"
}

resource "aws_ecr_repository" "artserviceecrrepository" {
  name = "artserviceecrrepository"
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "ecs/ecrrepository/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}
