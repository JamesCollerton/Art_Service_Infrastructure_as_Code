### Variables ###

variable "service_name" {
	description = "Name of the service to create"
}

variable "desired_count" {
	description = "Desired number of instances we would like running"
}

variable "container_port" {
	description = "Port the container will run on"
}

### Resources ###

resource "aws_ecs_service" "ecs-service" {
  	name            = "${var.service_name}"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.art-service-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.task_definition.family}:${max("${aws_ecs_task_definition.task_definition.revision}", "${data.aws_ecs_task_definition.task_definition.revision}")}"
  	desired_count   = "${var.desired_count}"

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = "${var.container_port}"
    	container_name    = "${var.service_name}"
	}
}
