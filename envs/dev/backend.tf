terraform {
  backend "s3" {
    bucket       = "seven-aws-sec-net-lab-tfstate-62780dda"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}
