resource "google_service_account" "bigquery-connector" {
  account_id   = "bigquery-connector"
  display_name = "service account used to write billing data to bigquery"
}

resource "google_service_account_key" "bigquery-connector" {
  service_account_id = google_service_account.bigquery-connector.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "bigquery-connector" {
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.bigquery-connector.email}"
}

resource "google_project_iam_binding" "write_acces" {
  role    = "roles/bigquery.dataEditor"
  members = compact(split(",", replace(var.write_members, " ", "")))
}

resource "google_project_iam_binding" "job_access" {
  role = "roles/bigquery.jobUser"
  members = compact(split(",", replace(var.job_members, " ", "")))
}

