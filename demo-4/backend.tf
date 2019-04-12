terraform {
  backend "s3" {
    bucket = "sample-bucket-west-2"
    key = "terraform/demo"
    region = "us-west-2"
    }
}
