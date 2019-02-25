resource "google_service_account" "bigquery-connector" {
  account_id   = "bigquery-connector"
  display_name = "service account used to write billing data to bigquery"
  project      = "${var.project_id}"
}

resource "google_service_account_key" "bigquery-connector" {
  service_account_id = "${google_service_account.bigquery-connector.name}"
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "bigquery-connector" {
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.bigquery-connector.email}"
  project = "${var.project_id}"
}


resource "google_project_iam_binding" "write_acces" {
  project = "${var.project_id}"
  role = "roles/bigquery.dataEditor"
  members = "${var.write_members}"
}