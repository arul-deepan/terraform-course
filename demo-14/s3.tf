resource "aws_s3_bucket" "b" {
    bucket = "mybucket-c29df112314354"
    acl = "private"

    tags {
        Name = "mybucket-c29df112314354"
    }
}
