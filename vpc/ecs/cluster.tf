resource "aws_ecs_cluster" "art-service-ecs-cluster" {
   name = "${var.ecs_cluster}"
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}

