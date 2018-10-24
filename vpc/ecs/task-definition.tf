data "template_file" "art-service-sourcing-data-service" {
  template = "${file("${path.module}/tasks/art-service-sourcing-data-service.json")}"

  #vars {
  #  image           = "${aws_ecr_repository.openjobs_app.repository_url}"
  #}
}

data "aws_ecs_task_definition" "art-service-sourcing-data-service" {
  depends_on = [ "aws_ecs_task_definition.art-service-sourcing-data-service" ]
  task_definition = "${aws_ecs_task_definition.art-service-sourcing-data-service.family}"
}

resource "aws_ecs_task_definition" "art-service-sourcing-data-service" {
  "family" = "art-services",
  "container_definitions" = "${data.template_file.art-service-sourcing-data-service.rendered}"
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}

