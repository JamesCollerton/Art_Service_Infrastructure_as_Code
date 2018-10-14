resource "aws_alb" "ecsloadbalancer" {
    name                = "ecsloadbalancer"
    security_groups     = ["${aws_security_group.ecsvpcsggeneric.id}"]
    subnets             = ["${aws_subnet.ecsvpceast1aSN0-0.id}", "${aws_subnet.ecsvpceast1aSN0-1.id}"]

    tags {
      Name = "ecsloadbalancer"
    }
}

resource "aws_alb_target_group" "ecstargetgroup" {
    name                = "ecstargetgroup"
    port                = "80"
    protocol            = "HTTP"
    vpc_id              = "${aws_vpc.ecsvpc.id}"

    health_check {
        healthy_threshold   = "5"
        unhealthy_threshold = "2"
        interval            = "30"
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = "5"
    }

    tags {
      Name = "ecstargetgroup"
    }
}

resource "aws_alb_listener" "ecsalblistener" {
    load_balancer_arn = "${aws_alb.ecsloadbalancer.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.ecstargetgroup.arn}"
        type             = "forward"
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

