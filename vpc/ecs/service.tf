resource "aws_ecs_service" "artservicesourcingdataecsservice" {
  	name            = "artservicesourcingdataecsservice"
  	iam_role        = "${aws_iam_role.ecsservicerole.name}"
  	cluster         = "${aws_ecs_cluster.artserviceecscluster.id}"
  	task_definition = "${aws_ecs_task_definition.artservicesourcingdataservice.family}:${max("${aws_ecs_task_definition.artservicesourcingdataservice.revision}", "${data.aws_ecs_task_definition.artservicesourcingdataservice.revision}")}"
  	desired_count   = 1

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecstargetgroup.arn}"
    	container_port    = 8082
    	container_name    = "sourcingdataservice"
	}
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}
