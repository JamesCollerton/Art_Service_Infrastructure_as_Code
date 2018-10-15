resource "aws_launch_configuration" "ecslaunchconfiguration" {
    name                        = "ecslaunchconfiguration"
    image_id                    = "ami-0922553b7b0369273"
    instance_type               = "t2.micro"
    iam_instance_profile        = "${aws_iam_instance_profile.ecsinstanceprofile.id}"

    # This is taken from the standard setup from the wizard
    root_block_device {
      volume_type = "standard"
      volume_size = 8
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    # Note, you need to create your own key pair on AWS first to use this
    security_groups             = ["${aws_security_group.ecsvpcsggeneric.id}"]
    associate_public_ip_address = "true"
    key_name                    = "${var.ecs_key_pair_name}"
    user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${var.vpc_name} >> /etc/ecs/ecs.config
                                  EOF
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}

