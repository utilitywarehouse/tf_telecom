locals {
  bucket_name = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
}

data "aws_iam_policy_document" "access" {
  statement {
    effect = "Allow"
    sid    = "ReadAccess"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
    principals {
      identifiers = compact(
        concat(
          split(",", replace(var.write_access, " ", "")),
          split(",", replace(var.read_access, " ", "")),
        ),
      )
      type = "AWS"
    }
  }
  statement {
    effect = "Allow"
    sid    = "ListBucketContents"
    actions = [
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:GetBucketLocation",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}",

    ]
    principals {
      identifiers = compact(
        concat(
          split(",", replace(var.write_access, " ", "")),
          split(",", replace(var.list_access, " ", "")),
        ),
      )
      type = "AWS"
    }
  }
  statement {
    effect = "Allow"
    sid    = "WriteAccess"
    actions = [
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
    principals {
      identifiers = compact(split(",", replace(var.write_access, " ", "")))
      type        = "AWS"
    }
  }
  statement {
    effect = "Deny"
    sid    = "DenyUnEncryptedObjectUploads"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
    principals {
      identifiers = [
        "*",
      ]
      type = "*"
    }
    condition {
      test = "StringNotEquals"
      values = [
        "AES256",
      ]
      variable = "s3:x-amz-server-side-encryption"
    }
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  tags = {
    terraform = "Managed by terraform"
    team      = var.team
    Name = local.bucket_name
  }
}

# AWS disabled s3 buckets ACLs:
# https://aws.amazon.com/about-aws/whats-new/2022/12/amazon-s3-automatically-enable-block-public-access-disable-access-control-lists-buckets-april-2023/
# We need to enable this manually and se object ownership. See:
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest#private-bucket-with-versioning-enabled
# https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/issues/223#issuecomment-1545649581
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.access.json
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl = "private"

  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]
}

# Block public access on private buckets for security audits
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  count  = var.create_cors_config ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  cors_rule {
    allowed_headers = var.cors_allowed_headers
    allowed_methods = var.cors_allowed_methods
    allowed_origins = var.cors_allowed_origins
    expose_headers = var.cors_expose_headers
    max_age_seconds = var.cors_max_age
  }
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}
