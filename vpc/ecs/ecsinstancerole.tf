resource "aws_iam_role" "ecsinstancerole" {
    name                = "ecsinstancerole"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecsinstancepolicy.json}"
}

data "aws_iam_policy_document" "ecsinstancepolicy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecsinstanceroleattachment" {
    role       = "${aws_iam_role.ecsinstancerole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# To pass the role information to the EC2 instances when they are launched.
resource "aws_iam_instance_profile" "ecsinstanceprofile" {
    name = "ecsinstanceprofile"
    path = "/"
    role = "${aws_iam_role.ecsinstancerole.id}"
    provisioner "local-exec" {
      command = "sleep 10"
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

