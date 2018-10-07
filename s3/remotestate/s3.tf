# Must set AWS_SDK_LOAD_CONFIG=1

# Credentials must be in ~/.aws/credentials under the appropriate profile

# As this is the setup of the terraform remote state we must initialise
# the S3 bucket and then port the existing state over. All other terraform
# configurations should then be able to use this as a backend.

provider "aws" {
  region     = "us-east-1"
  profile    = "s3administrator"
}

resource "aws_s3_bucket" "b" {
  bucket = "artserviceremotestatebucket"
  acl    = "private"

  tags {
    Name        = "artserviceremotestatebucket"
  }
}

terraform {
  backend "s3" {
    bucket  = "artserviceremotestatebucket"
    key     = "s3/remotestate/terraform.tfstate"
    region  = "us-east-1"
    profile = "s3administrator"	
  }
}
