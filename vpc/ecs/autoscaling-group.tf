resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = "${var.max_instance_size}"
    min_size                    = "${var.min_instance_size}"
    desired_capacity            = "${var.desired_capacity}"
    vpc_zone_identifier         = ["ecsvpceast1aSN0-0", "ecsvpceast1aSN0-1"]
    launch_configuration        = "${aws_launch_configuration.ecslaunchconfiguration.name}"
    health_check_type           = "ELB"
}
