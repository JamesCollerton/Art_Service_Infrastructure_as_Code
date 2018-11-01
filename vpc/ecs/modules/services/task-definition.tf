### Variables ###

variable "template_file_name" {
	description = "Name of the task definition file"
}

data "template_file" "template_file" {
  template = "${file("${path.module}/tasks/${var.template_file_name}.json")}"
}

### Resources ###

data "aws_ecs_task_definition" "task_definition" {
  depends_on = [ "aws_ecs_task_definition.task_definition" ]
  task_definition = "${aws_ecs_task_definition.task_definition.family}"
}

resource "aws_ecs_task_definition" "task_definition" {
  "family" = "art-services",
  "container_definitions" = "${data.template_file.template_file.rendered}"
}
