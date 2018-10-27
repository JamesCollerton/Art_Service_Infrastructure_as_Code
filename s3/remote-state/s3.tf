# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials under the appropriate profile

# As this is the setup of the terraform remote state we must initialise
# the S3 bucket and then port the existing state over. All other terraform
# configurations should then be able to use this as a backend.

provider "aws" {
  region     = "us-east-1"
  profile    = "s3administrator"
}

resource "aws_s3_bucket" "art-service-remote-state-bucket" {
  bucket = "art-service-remote-state-bucket"
  acl    = "private"
  force_destroy = "true"

  tags {
    Name        = "art-service-remote-state-bucket"
  }
}

terraform {
  backend "s3" {
    bucket  = "art-service-remote-state-bucket"
    key     = "s3/remote-state/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"	
  }
}
