# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials

# This uses a combination of https://docs.aws.amazon.com/AmazonECS/latest/developerguide/get-set-up-for-amazon-ecs.html and http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster for the setup.

provider "aws" {
  region     = "us-east-1"
  profile    = "vpcadministrator"
}

# Define a vpc
resource "aws_vpc" "ecsvpc" {
  cidr_block = "${var.network_cidr}"
  tags {
    Name = "${var.vpc_name}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ecsvpcinternetgateway" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  tags {
    Name = "ecsvpcinternetgateway"
  }
}

# Public subnet one (need two for load balancing)
resource "aws_subnet" "ecsvpceast1aSN0-0" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  cidr_block = "${var.public_01_cidr}"
  availability_zone = "us-east-1a"
  tags {
    Name = "ecsvpceast1aSN0-0"
  }
}

# Public subnet two
resource "aws_subnet" "ecsvpceast1aSN0-1" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  cidr_block = "${var.public_02_cidr}"
  availability_zone = "us-east-1b"
  tags {
    Name = "ecsvpceast1aSN0-1"
  }
}

# Routing table for public subnet one
resource "aws_route_table" "ecsvpcSN0-0RT" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecsvpcinternetgateway.id}"
  }
  tags {
    Name = "ecsvpcSN0-0RT"
  }
}

# Routing table for public subnet two
resource "aws_route_table" "ecsvpcSN0-1RT" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ecsvpcinternetgateway.id}"
  }
  tags {
    Name = "ecsvpcSN0-1RT"
  }
}

# Associate the routing table to public subnet one
resource "aws_route_table_association" "ecsvpceast1aSN0-0RTAssn" {
  subnet_id = "${aws_subnet.ecsvpceast1aSN0-0.id}"
  route_table_id = "${aws_route_table.ecsvpcSN0-0RT.id}"
}

# Associate the routing table to public subnet one
resource "aws_route_table_association" "ecsvpceast1aSN0-1RTAssn" {
  subnet_id = "${aws_subnet.ecsvpceast1aSN0-1.id}"
  route_table_id = "${aws_route_table.ecsvpcSN0-1RT.id}"
}

# ECS Instance Security group
resource "aws_security_group" "ecsvpcsggeneric" {
    name = "ecsvpcsggeneric"
    description = "Generic security group for accessing the ECS VPC."
    vpc_id = "${aws_vpc.ecsvpc.id}"

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
   }

   # Sourcing Data Service Port
   ingress {
      from_port = 8082
      to_port = 8082
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

   ingress {
      from_port = 0
      to_port = 0
      protocol = "tcp"
      cidr_blocks = [
         "${var.public_01_cidr}",
         "${var.public_02_cidr}"]
    }
    
    # Allow all traffic to private SN
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }

    tags { 
       Name = "ecsvpcgeneric"
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
