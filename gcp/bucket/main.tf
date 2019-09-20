resource "google_storage_bucket" "bucket" {
  name = format(
    "uw-%s-%s-%s",
    replace(var.team, "/^uw-/", ""),
    var.name,
    var.env,
  )
  location = "EU"
}

resource "google_storage_bucket_acl" "acl" {
  bucket = google_storage_bucket.bucket.name
  role_entity = [
    concat(
      format("OWNER:project-owners-%s", var.project_number),
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

