locals {
  bucket_name = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
}

data aws_iam_policy_document "vault" {
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*",
    ]
  }
}

resource aws_iam_role_policy "vault" {
  name = local.bucket_name
  role = var.vault_role_id
  policy = data.aws_iam_policy_document.vault.json
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

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}
