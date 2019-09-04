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
  acl    = "private"
  policy = data.aws_iam_policy_document.access.json
  tags = {
    terraform = "Managed by terraform"
    team      = var.team
  }
}

