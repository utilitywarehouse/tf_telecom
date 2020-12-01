data aws_iam_policy_document "vault" {
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${format(
        "uw-%s-%s-%s",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )}",
      "arn:aws:s3:::${format(
          "uw-%s-%s-%s",
          replace(var.team, "/^uw-/", ""),
          var.name,
          var.env,
        )}/*",
    ]
  }
}

resource aws_iam_role_policy "vault" {
  name = format(
        "uw-%s-%s-%s-vault",
        replace(var.team, "/^uw-/", ""),
        var.name,
        var.env,
      )
  role = var.vault_role_id
  policy = data.aws_iam_policy_document.vault.json
}

resource "aws_s3_bucket" "bucket" {
  bucket = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
  acl    = "private"
  tags = {
    terraform = "Managed by terraform"
    team      = var.team
  }
  versioning {
    enabled = var.versioning
  }
}
