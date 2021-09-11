resource "aws_s3_bucket" "minecraft-data" {
  bucket = local.bucket
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "dmalch-minecraft-data-access" {
  bucket                  = local.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "minecraft-data-2" {
  bucket = local.bucket2
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "dmalch-minecraft-data-access-2" {
  bucket                  = local.bucket2
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
