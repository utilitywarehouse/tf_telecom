resource "google_storage_bucket" "bucket" {
  name = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
  location = "EU"
  project  = var.project_id
}

resource "google_storage_bucket_acl" "acl" {
  bucket = google_storage_bucket.bucket.name
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  role_entity = [
    concat(
      [format("OWNER:project-owners-%s", var.project_number)],
      formatlist(
        "WRITER:user-%s",
        compact(split(",", replace(var.writer_users, " ", ""))),
      ),
      formatlist(
        "READER:user-%s",
        compact(split(",", replace(var.reader_users, " ", ""))),
      ),
    ),
  ]
}

