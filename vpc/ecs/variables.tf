########################### General Variables #############################

variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
  description = "EC2 instance key pair name"
}

variable "region" {
  description = "AWS region"
}

variable "availability_zone" {
  description = "Availability zone used for the ecs cluster, based on region"
  default = {
    us-east-1 = "us-east-1"
  }
}

########################### VPC Config #####################################

variable "vpc_name" {
  description = "VPC name"
}

variable "network_cidr" {
  description = "IP addressing for network"
}

variable "public_01_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

variable "public_02_cidr" {
  description = "Public 0.0 CIDR for externally accessible subnet"
}

########################### Autoscale Config ################################

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}
