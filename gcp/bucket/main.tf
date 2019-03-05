
resource "google_storage_bucket" "bucket" {
  name = "${var.name}"
  location = "EU"
  project = "${var.project_id}"
}

resource "google_storage_bucket_acl" "acl" {
  bucket = "${google_storage_bucket.bucket.name}"
  role_entity = [
    "${concat(list(format("OWNER:project-owners-%s",var.project_number)), formatlist("WRITER:user-%s", compact(split(",",replace(var.writer_users, " ", "")))), formatlist("READER:user-%s", compact(split(",",replace(var.reader_users, " ", "")))))}"
  ]
}