# Art Service Infrastructure as Code

This is the repository for storing all of the art service's infrastructure as code using Terraform.

## Overview

Currently all infrastructure is set up using Terraform on AWS. Each different type of AWS service is given its own administrator IAM user, employing that for the necessary permissions. All terraform should also share the same remote backend on AWS S3 so that state is shareable regardless of the developer.

## Shared Remote State

This is set up as an S3 bucket on AWS. For initial setup you will need to initialise the S3 bucket and then migrate the existing state over. The file path for the state should then match:

```
servicetype/serviceimplementation/furtherdetails/terraform.tstate
```

For example, for the `artservicesourcingdataservice` the file path should be:

```
ecs/ecrrepositories/artservicesourcingdataservice/terraform.tstate
```

This should also match the folder structure in the repository.

## ECS

### ECR

Each service will need its own ECR associated with it, therefore there will be a folder for each service. The responsibilities of the file is to create the ECR and then associate it with the remote state backend.

## S3

### Shared Remote State

One S3 bucket has been set up with the responsibility of managing shared remote state. Note, this will need to be bootstrapped if you are setting it up yourself. Currently it uses itself as a backend, but when first creating it you will need to use a local backend before migrating it over.
