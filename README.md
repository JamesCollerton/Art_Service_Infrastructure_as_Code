# Art Service Infrastructure as Code

This is the repository for storing all of the art service's infrastructure as code using Terraform.

## Overview

Currently all infrastructure is set up using Terraform on AWS. Each different type of AWS service is given its own administrator IAM user, employing that for the necessary permissions. All terraform should also share the same remote backend on AWS S3 so that state is shareable regardless of the developer.

## Shared Remote State

This is set up as an S3 bucket on AWS. For initial setup you will need to initialise the S3 bucket and then migrate the existing state over. The file path for the state should then match:

```
service-type/service-implementation/further-details/terraform.tstate
```

For example, for the `art-service-sourcing-data-service` the file path should be:

```
ecs/ecr-repositories/art-service-sourcing-data-service/terraform.tstate
```

This should also match the folder structure in the repository.

## ECS

### How Does ECS Work?

ECS is the AWS Docker container service which handles the orchestration and provisioning of Docker containers. It works as below:

![ECS Image](README/ECS_Image.png)

There exists a cluster of EC2 container instances. Running amongst the EC2 instances is a service. That service can hold multiple instances of a task. The service is responsible for scaling the task definitions up and down as well as bringing them back up if they fall over.

### ECS Cluster

#### Tasks and Task Definitions

A task definition is the blueprint of how a docker container should launch. The task is then the running instance of the task definition. They use `.json` files similar to the below in order to define what a docker instance launch looks like.

```
[     
    {
        "name": "sourcing-data-service",
        "image": "257777415217.dkr.ecr.us-east-1.amazonaws.com/artservicesourcingdataservice:latest",
        "cpu": 10,
        "memory": 500,
        "portMappings": [
            {
                "containerPort": 8082,
                "hostPort": 8082
            }
        ],
      "command": [],
        "essential": true
    }
]
```

Here we have an image artservicesourcingdataservice being launched from the attached ECR. It is exposed on port 8082 (where our application is listening).

#### Services

These define long running tasks of the same task definition. 

```
resource "aws_ecs_service" "art-service-sourcing-data-ecs-service" {
  	name            = "art-service-sourcing-data-ecs-service"
  	iam_role        = "${aws_iam_role.ecs-service-role.name}"
  	cluster         = "${aws_ecs_cluster.art-service-ecs-cluster.id}"
  	task_definition = "${aws_ecs_task_definition.art-service-sourcing-data-service.family}:${max("${aws_ecs_task_definition.art-service-sourcing-data-service.revision}", "${data.aws_ecs_task_definition.art-service-sourcing-data-service.revision}")}"
  	desired_count   = 1

  	load_balancer {
    	target_group_arn  = "${aws_alb_target_group.ecs-target-group.arn}"
    	container_port    = 8082
    	container_name    = "sourcing-data-service"
	}
}
```

The above defines a service which holds the task defined previously. We see it is exposed on port 8082 and aims to have one instance running. The load balancer then distributes traffic across all instances of the task. The ECS scheduler automatically creates new task instances should any instance terminate unexpectedly.

#### Launch Configurations

#### ECS Service Role and ECS Instance Role

#### Cluster

The cluster is then the logic group of EC2 instances running the ecs-agent software. Each of the EC2 instances is referred to as a container instance.

#### Autoscaling Group

#### Application Load Balancer 

### VPC

#### Internet Gateways

#### Public Subnets

#### Routing Tables (and subnet association tables)

#### Security Groups


### ECR

Each service will need its own ECR associated with it, therefore there will be a folder for each service. The responsibilities of the file is to create the ECR and then associate it with the remote state backend.

## S3

### Shared Remote State

One S3 bucket has been set up with the responsibility of managing shared remote state. Note, this will need to be bootstrapped if you are setting it up yourself. Currently it uses itself as a backend, but when first creating it you will need to use a local backend before migrating it over.
