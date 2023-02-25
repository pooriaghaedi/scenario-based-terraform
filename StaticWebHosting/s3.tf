resource "aws_s3_bucket" "website" {
 bucket = "${local.name}-website-${local.region}"
}

resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.website.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "bucketacl" {
 bucket = aws_s3_bucket.website.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}


resource "aws_s3_bucket_policy" "websiteOAI" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.allowOAI.json
}

data "aws_iam_policy_document" "allowOAI" {
  statement {
    principals {
      type = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.websiteOAI.iam_arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}