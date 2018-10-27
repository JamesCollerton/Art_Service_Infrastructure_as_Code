resource "aws_ecs_service" "art-service-sourcing-data-ecs-service" {
  	name            = "art-service-sourcing-data-ecs-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.art-service-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.art-service-sourcing-data-service.family}:${max("${aws_ecs_task_definition.art-service-sourcing-data-service.revision}", "${data.aws_ecs_task_definition.art-service-sourcing-data-service.revision}")}"
  	desired_count   = 1

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = 8082
    	container_name    = "sourcing-data-service"
	}
}

terraform {
  backend "s3" {
    bucket  = "art-service-remote-state-bucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}
