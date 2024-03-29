data "aws_iam_policy_document" "access" {
  statement {
    effect = "Allow"
    sid    = "ReadAccess"
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${format(
        "uw-%s-%s-%s",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )}/*",
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
      "arn:aws:s3:::${format(
        "uw-%s-%s-%s",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )}",
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
      "arn:aws:s3:::${format(
        "uw-%s-%s-%s",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )}/*",
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
      "arn:aws:s3:::${format(
        "uw-%s-%s-%s",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )}/*",
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
  bucket = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
  tags = {
    terraform = "Managed by terraform"
    team      = var.team
  }
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.access.json
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl = "private"
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
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
