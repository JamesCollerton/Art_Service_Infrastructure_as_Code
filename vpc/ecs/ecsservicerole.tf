resource "aws_iam_role" "ecsservicerole" {
    name                = "ecsservicerole"
    path                = "/"
    assume_role_policy  = "${data.aws_iam_policy_document.ecsservicepolicy.json}"
}

resource "aws_iam_role_policy_attachment" "ecsserviceroleattachment" {
    role       = "${aws_iam_role.ecsservicerole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecsservicepolicy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ecs.amazonaws.com"]
        }
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

