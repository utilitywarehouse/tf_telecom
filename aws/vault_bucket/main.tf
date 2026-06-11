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


resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = var.versioning
  }
}
