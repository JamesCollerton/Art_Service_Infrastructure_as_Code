resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = "${var.max_instance_size}"
    min_size                    = "${var.min_instance_size}"
    desired_capacity            = "${var.desired_capacity}"
    vpc_zone_identifier         = ["${aws_subnet.ecsvpceast1aSN0-0.id}", "${aws_subnet.ecsvpceast1aSN0-1.id}"]
    launch_configuration        = "${aws_launch_configuration.ecslaunchconfiguration.name}"
    health_check_type           = "ELB"
}
