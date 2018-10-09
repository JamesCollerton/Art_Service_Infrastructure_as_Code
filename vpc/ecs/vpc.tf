# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials

provider "aws" {
  region     = "us-east-1"
  profile    = "ecsadministrator"
}

# Define a vpc
resource "aws_vpc" "ecsvpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "ecsvpc"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ecsvpcinternetgateway" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  tags {
    Name = "ecsvpcinternetgateway"
  }
}

# Public subnet
resource "aws_subnet" "ecsvpceast1aSN0-0" {
  vpc_id = "${aws_vpc.ecsvpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags {
    Name = "ecsvpceast1aSN0-0"
  }
}

# Routing table for public subnet
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

# Associate the routing table to public subnet
resource "aws_route_table_association" "ecsvpceast1aSN0-0RTAssn" {
  subnet_id = "${aws_subnet.ecsvpceast1aSN0-0.id}"
  route_table_id = "${aws_route_table.ecsvpcSN0-0RT.id}"
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "vpc/ecs/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"
  }
}
