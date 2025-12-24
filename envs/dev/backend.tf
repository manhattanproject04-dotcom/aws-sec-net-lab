terraform {
  backend "s3" {
    bucket         = "seven-aws-sec-net-lab-tfstate-62780dda"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "seven-aws-sec-net-lab-tflock"
    encrypt        = true
  }
}
