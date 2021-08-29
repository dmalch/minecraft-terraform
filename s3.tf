module "s3" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.bucket
  acl    = "private"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
