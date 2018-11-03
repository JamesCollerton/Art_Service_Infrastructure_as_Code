module "art-service-manipulating-data-service" {
	source = "modules/services"

	service_name 		= "art-service-manipulating-data-service"
	desired_count 		= 1
	container_port 		= 8083
	template_file_name 	= "art-service-manipulating-data-service"
	ecs_service_role_name	= "${aws_iam_role.ecs-service-role.name}"
	ecs_cluster_id 		= "${aws_ecs_cluster.art-service-ecs-cluster.id}"
	ecs_target_group_arn    = "${aws_alb_target_group.ecs-target-group.arn}"
}

terraform {
  backend "s3" {
    bucket  = "art-service-remote-state-bucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}

