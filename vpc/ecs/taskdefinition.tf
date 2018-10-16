data "template_file" "artservicesourcingdataservice" {
  template = "${file("${path.module}/tasks/artservicesourcingdataservice.json")}"

  #vars {
  #  image           = "${aws_ecr_repository.openjobs_app.repository_url}"
  #}
}

data "aws_ecs_task_definition" "artservicesourcingdataservice" {
  depends_on = [ "aws_ecs_task_definition.artservicesourcingdataservice" ]
  task_definition = "${aws_ecs_task_definition.artservicesourcingdataservice.family}"
}

resource "aws_ecs_task_definition" "artservicesourcingdataservice" {
  "family" = "artservices",
  "container_definitions" = "${data.template_file.artservicesourcingdataservice.rendered}"
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}

