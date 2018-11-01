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

variable "ecs_service_role_name" {
	description = "Name of the ECS service role"
}

variable "ecs_cluster_id" {
	description = "Id for the ECS cluster"
}

variable "ecs_target_group_arn" {
	description = "ARN for the target group"
}

### Resources ###

resource "aws_ecs_service" "ecs-service" {
  	name            = "${var.service_name}"
  	iam_role        = "${var.ecs_service_role_name}"
  	cluster         = "${var.ecs_cluster_id}"
  	task_definition = "${aws_ecs_task_definition.task_definition.family}:${max("${aws_ecs_task_definition.task_definition.revision}", "${data.aws_ecs_task_definition.task_definition.revision}")}"
  	desired_count   = "${var.desired_count}"

  	load_balancer {
    	target_group_arn  = "${var.ecs_target_group_arn}"
    	container_port    = "${var.container_port}"
    	container_name    = "${var.service_name}"
	}
}
