module "art-service-ecr" {
	source = "../modules"
	service_name = "art-service-manipulating-data-service"
}

 terraform {
   backend "s3" {
     bucket  = "art-service-remote-state-bucket"
     key     = "ecs/ecr-repositories/art-service-manipulating-data-service/terraform.tfstate"
     region  = "us-east-1"
     profile = "s3administrator"
   }
 }
